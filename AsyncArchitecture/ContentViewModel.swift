//
//  ContentViewModel.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import Foundation
import Dependencies
import Observation
import CasePaths
import Combine

@MainActor
class ContentViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var statusText: String = ""

    @Published var destination: Destination?

    @Dependency(\.networkMonitor) var networkMonitor
    @Dependency(\.analyticsService) var analyticsService

    private var repository: Repository
    private var cancellable: AnyCancellable?
    private var cancellables: [AnyCancellable] = []

//    @Published var persons: LazyMapSequence<LazySequence<[PersonDTO]>.Elements, Person> = [].lazy.map { _ in fatalError() }
    @Published var persons: LazyArray<PersonDTO, Person> = .init([], map: { _ in fatalError() })

    @CasePathable
    enum Destination {
        case detail(ContentDetailViewModel)
        case contentData
    }

    init() {
        repository = Repository(client: Client())
        
        networkMonitor.objectWillChange
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] _ in
                self.objectWillChange.send()
            })
            .store(in: &cancellables)
    }

    func fetch() async throws {
        isLoading = true
        defer { isLoading = false }
        let personsDTO = try await repository.fetchPersons()

        self.persons = LazyArray(personsDTO, map: {
            debugPrint("creating person \($0.name)")
            return Person($0)
        })
        
        self.statusText = "Loaded \(self.persons.count) objects"
    }

    func gotoNextPage() {
        self.destination = .detail(ContentDetailViewModel(persons: &self.persons))
    }
    
    func gotoContentData() {
        self.destination = .contentData
    }

}

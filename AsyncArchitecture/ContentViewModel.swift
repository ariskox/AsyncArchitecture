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

    private let repository: Repository
    private var cancellable: AnyCancellable?
    private var cancellables: [AnyCancellable] = []

    @Published var persons: [Person] = []

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
        self.persons = try await repository.fetchPersons()

        self.statusText = "Loaded \(self.persons.count) objects"
    }

    func gotoNextPage() {
        self.destination = .detail(ContentDetailViewModel(persons: self.persons))
    }
    
    func gotoContentData() {
        self.destination = .contentData
    }

}

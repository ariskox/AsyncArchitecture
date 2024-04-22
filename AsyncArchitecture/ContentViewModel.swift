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
    @Published var activePerson: Person?

    @Published var destination: Destination?

    @Dependency(\.networkMonitor) var networkMonitor
    @Dependency(\.analyticsService) var analyticsService

    private var repository = Repository()
    private var cancellable: AnyCancellable?

    @CasePathable
    enum Destination {
        case detail(ContentDetailViewModel)
    }

    func fetch() async throws {
        isLoading = true
        defer { isLoading = false }
        let person = try await repository.fetchPerson()
        self.activePerson = person
        
        cancellable = self.activePerson?.objectWillChange
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] _ in
                self.objectWillChange.send()
            })
    }

    func changeName() async throws {
        guard let activePerson else { return }
        isLoading = true
        defer { isLoading = false }

        self.activePerson?.name = "New name 1"
        try await repository.save(activePerson)
        await analyticsService.sendEvent("Name changed")
    }

    func changeNameByAsyncChange() {
        Task {
            isLoading = true
            defer { isLoading = false }
            try await Task.sleep(nanoseconds: NSEC_PER_SEC * 1)
            self.activePerson?.name = "New name 2"
        }
    }

    func gotoNextPage() {
        guard let activePerson = self.activePerson else { return }
        self.destination = .detail(ContentDetailViewModel(person: activePerson))
    }
}

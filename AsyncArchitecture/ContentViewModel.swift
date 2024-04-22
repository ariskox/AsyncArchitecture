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
    @Published var value: String = ""

    @Published var destination: Destination?

    @Dependency(\.networkMonitor) var networkMonitor
    @Dependency(\.analyticsService) var analyticsService

    @Published var actor = ActorObject()

    private var repository = Repository()
    private var cancellable: AnyCancellable?
    private var cancellables: [AnyCancellable] = []

    @CasePathable
    enum Destination {
        case detail(ContentDetailViewModel)
    }

    init() {
        actor.objectWillChange
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [unowned self] _ in
                self.objectWillChange.send()
                self.value = "Changed actor"
            })
            .store(in: &cancellables)

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
        let person = try await repository.fetchPersons().first!
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

//        self.activePerson?.name = "New name 1"
        self.activePerson?.setName("New name 1")
        try await repository.save(activePerson)
        await analyticsService.sendEvent("Name changed")
    }

    func changeNameByAsyncChange() {
        Task {
            isLoading = true
            defer { isLoading = false }
            try await Task.sleep(nanoseconds: NSEC_PER_SEC * 1)
//            self.activePerson?.name = "New name 2"
            self.activePerson?.setName("New name 2")
        }
    }

    func gotoNextPage() {
        guard let activePerson = self.activePerson else { return }
        self.destination = .detail(ContentDetailViewModel(person: activePerson))
    }

    func changeActor() {
        Task {
            await actor.changeName()
        }
    }
}

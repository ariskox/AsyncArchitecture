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

@MainActor
@Observable
class ContentViewModel {
    var isLoading = false
    var name: String = ""
    var surname: String = ""

    var destination: Destination? {
      didSet { self.bind() }
    }

    @ObservationIgnored
    @Dependency(\.networkMonitor) var networkMonitor
    
    @ObservationIgnored
    @Dependency(\.analyticsService) var analyticsService

    @ObservationIgnored
    private var repository = Repository()

    @ObservationIgnored
    var activePerson: Person?

    @CasePathable
    enum Destination {
        case detail(ContentDetailViewModel)
    }

    private func bind() {

    }

    func fetch() async throws {
        isLoading = true
        defer { isLoading = false }
        let person = try await repository.fetchPerson()
        self.activePerson = person
        await refreshUI()
    }

    func changeName() async throws {
        guard let activePerson else { return }
        isLoading = true
        defer { isLoading = false }

        await activePerson.changeName("Aris1")
        try await repository.save(activePerson)
        await refreshUI()
        await analyticsService.sendEvent("Name changed")
    }

    func changeNameByAsyncChange() {
        guard let activePerson else { return }
        Task {
            try await Task.sleep(nanoseconds: NSEC_PER_SEC * 1)
            await activePerson.changeName("Aris2")
            // TODO: change should be propagated immediately
//            await refreshUI()
//            self.name = "BG Change"
        }
    }

    func refreshUI() async {
        self.name = await activePerson?.name ?? ""
        self.surname = await activePerson?.surname ?? ""
    }

    func gotoNextPage() {
        guard let activePerson = self.activePerson else { return }
        self.destination = .detail(ContentDetailViewModel(person: activePerson))
    }
}

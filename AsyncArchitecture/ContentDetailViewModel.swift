//
//  ContentDetailViewModel.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import Foundation

@MainActor
@Observable
class ContentDetailViewModel {
    private let activePerson: Person

    var name: String = ""

    init(person: Person) {
        self.activePerson = person

        // TODO: fix me
        Task {
            await refreshUI()
        }
    }

    func refreshUI() async {
        self.name = await activePerson.name
    }
}

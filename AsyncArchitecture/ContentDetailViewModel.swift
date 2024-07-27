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
    private(set) var persons: [Person]

    init(persons: [Person]) {
        self.persons = persons
    }
}

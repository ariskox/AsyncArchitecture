//
//  Person.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import Foundation

@MainActor
final class Person: ObservableObject, Identifiable {
    let id: String
    @Published private(set) var name: String!
    @Published private(set) var surname: String!

    init(id: String, name: String, surname: String) {
        self.id = id
        self.name = name
        self.surname = surname
    }

    init(_ personDTO: PersonDTO) {
        self.id = personDTO.id
        self.name = personDTO.name
        self.surname = personDTO.surname
    }
}

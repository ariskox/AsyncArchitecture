//
//  Person.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import Foundation

@MainActor
final class Person: ObservableObject {
    @Published var name: String
    @Published var surname: String

    init(name: String, surname: String) {
        self.name = name
        self.surname = surname
    }

    init(_ personDTO: PersonDTO) {
        self.name = personDTO.name
        self.surname = personDTO.surname
    }
}


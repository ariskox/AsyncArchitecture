//
//  Person.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import Foundation

actor Person {
    var name: String
    var surname: String

    init(name: String, surname: String) {
        self.name = name
        self.surname = surname
    }

    init(_ personDTO: PersonDTO) {
        self.name = personDTO.name
        self.surname = personDTO.surname
    }

    func changeName(_ newName: String) {
        self.name = newName
    }
}


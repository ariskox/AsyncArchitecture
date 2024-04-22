//
//  Person.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import Foundation

actor ActorObject: ObservableObject {
    @Published var name: String = "Actor 1"

    func changeName() {
        self.name = "Actor 2"
    }
}

final class Person: ObservableObject, @unchecked Sendable {
    @Published private(set) var name: String
    @Published private(set) var surname: String

    init(name: String, surname: String) {
        self.name = name
        self.surname = surname
    }

    init(_ personDTO: PersonDTO) {
        self.name = personDTO.name
        self.surname = personDTO.surname
    }

    private var dispatchQueue = DispatchQueue(label: "Person")
    func setName(_ name: String) {
        dispatchQueue.sync {
            self.name = name
        }
    }
}


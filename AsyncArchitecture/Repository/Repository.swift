//
//  Repository.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import Foundation

actor Repository {
    var client: Client = Client()

    func fetchPerson() async throws -> Person {
        assert(!Thread.isMainThread)
        let resource = Resource<PersonDTO>(urlRequest: URLRequest(url: URL(string: "https://api.example.com/persons")!))
        let personDTO = try await client.fetchResource(resource)
        let person = await Person(personDTO)

        return person
    }

    func save(_ person: Person) async throws {
        try await Task.sleep(nanoseconds: NSEC_PER_SEC * 1)
    }
}

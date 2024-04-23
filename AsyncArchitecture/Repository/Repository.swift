//
//  Repository.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import Foundation

actor Repository {
    var client: Client

    init(client: Client) {
        self.client = client
    }
    
    func fetchPersons() async throws -> [Person] {
        assert(!Thread.isMainThread)
        let resource = await client.getResource()
        let personDTO = try await client.fetchResource(resource)

        var persons: [Person] = []

        for _ in 1...100000 {
            persons.append(Person(personDTO))
        }

        return persons
    }

    func save(_ person: Person) async throws {
        try await Task.sleep(nanoseconds: NSEC_PER_SEC * 1)
    }
}

//
//  Repository.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import Foundation

actor Repository {
    let client: Client

    init(client: Client) {
        self.client = client
    }
    
    func fetchPersons() async throws -> sending [Person] {
        assert(!Thread.isMainThread)
        let resource = await client.getResource()
        
        // simulate fetching a resource
        // Normal we'd get a 'person DTO' here
        let _ = try await client.fetchResource(resource)

        // just build 1000 random items
        return (1...1000).map { i in
            Person(
                id: UUID().uuidString,
                name: "name \(i)",
                surname: "surname \(i)"
            )
        }
    }

    func save(_ person: Person) async throws {
        try await Task.sleep(nanoseconds: NSEC_PER_SEC * 1)
    }
}


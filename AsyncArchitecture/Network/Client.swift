//
//  Client.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import Foundation

actor Client {
    func getResource() async -> Resource<PersonDTO> {
        return Resource<PersonDTO>(urlRequest: URLRequest(url: URL(string: "https://www.example.com")!))
    }

    func fetchResource(_ resource: Resource<PersonDTO>) async throws -> PersonDTO {
        try await Task.sleep(nanoseconds: NSEC_PER_SEC * 1)
        let unused = try resource.parse(
            """
            {
                "name": "Aris",
                "surname": "Test"
            }
            """.data(using: .utf8)!
        )

        return unused
    }
}

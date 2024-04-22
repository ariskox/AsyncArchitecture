//
//  Client.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import Foundation

actor Client {
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

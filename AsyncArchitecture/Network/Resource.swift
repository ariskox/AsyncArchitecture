//
//  Resource.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import Foundation

final class Resource<A: Sendable>: Sendable {
    let urlRequest: URLRequest
    let parse: @Sendable (Data) throws -> A
    let validate: @Sendable (String?) -> Bool

    init(urlRequest: URLRequest,
                parse: @escaping @Sendable (Data) throws -> A = Parser().parse,
                validate: @escaping @Sendable (String?) -> Bool = Validator().validate) {
        self.urlRequest = urlRequest
        self.parse = parse
        self.validate = validate
    }

}

extension Resource {
    @Sendable func paged(page: Int, pageSize: Int) -> Resource<A> {
        var newRequest = urlRequest

        if let url = urlRequest.url {
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []

            queryItems += [
                URLQueryItem(name: "limit", value: String(pageSize)),
                URLQueryItem(name: "offset", value: String(page * pageSize))
            ]
            urlComponents.queryItems = queryItems
            newRequest.url = urlComponents.url
        }

        return Resource(urlRequest: newRequest,
                        parse: parse,
                        validate: validate)
    }
}

struct Parser<A: Sendable>: Sendable {
    @Sendable func parse(_ data: Data) throws -> A {
        switch A.self {
        case let decodableType as Decodable.Type:
            // Use openedJSONDecode with typeerasure cause decode(_:from:) has a generic placeholder T : Decodable:
            // https://stackoverflow.com/questions/54963038/codable-conformance-with-erased-types
            // swiftlint:disable:next force_cast
            return try decodableType.openedJSONDecode(decoder: JSONDecoder(), data: data) as! A
        case is Void.Type:
            // swiftlint:disable:next force_cast
            return Void() as! A
        case is Data.Type:
            // swiftlint:disable:next force_cast
            return data as! A
        default:
            throw ResourceError.unableToParse
        }
    }
    init() {}

}

enum ResourceError: Error {
    case unableToParse
    case noData
    case invalidHTTPResponse
    case invalidHTTPStatusCode(Int)
    case invalidContentType(String?)
}

extension Decodable {
    static func openedJSONDecode(decoder: JSONDecoder, data: Data) throws -> Self {
        return try decoder.decode(self, from: data)
    }
}


final class Validator: Sendable {
    let acceptableContentType: String

    init(contentType: String = "application/json") {
        self.acceptableContentType = contentType
    }

    @Sendable func validate(contentType: String?) -> Bool {
        guard let contentType = contentType else {
            return false
        }

        return contentType.hasPrefix(acceptableContentType)
    }

}

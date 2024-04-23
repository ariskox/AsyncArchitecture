//
//  LazyArray.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 23/4/24.
//

import Foundation

class LazyArray<ElementIn, ElementOut>: RandomAccessCollection, @unchecked Sendable {
    private var arrayIn: [ElementIn?]
    private var arrayOut: [ElementOut?]
    private let mapping: (ElementIn) -> (ElementOut)

    typealias Index = [Element?].Index
    typealias Element = ElementOut

    init(_ array: [ElementIn], map: @escaping (ElementIn) -> (ElementOut)) {
        self.arrayIn = array
        self.arrayOut = Array<Element?>.init(repeating: nil, count: array.count)
        self.mapping = map
    }

    var startIndex: Index { return arrayOut.startIndex }
    var endIndex: Index { return arrayOut.endIndex }

    private var lock = NSLock()

    // Required subscript, based on a dictionary index
    subscript(index: Index) -> Iterator.Element {
        get {
            lock.lock()
            defer { lock.unlock() }
            let existingItem = arrayOut[index]
            if existingItem != nil { return existingItem! }

            let created = mapping(arrayIn[index]!)
            arrayOut[index] = created
            arrayIn[index] = nil // no longer necessary. free memory

            return created
        }
    }

    // Method that returns the next index when iterating
    func index(after i: Index) -> Index {
        return arrayOut.index(after: i)
    }
}

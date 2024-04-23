//
//  Item.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 23/4/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date

    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

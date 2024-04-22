//
//  NavigationLazyView.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import SwiftUI

/// Use this wrapper to have lazy navigation links
public struct NavigationLazyView<Content: View>: View {
    let build: () -> Content

    public init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    public var body: Content {
        build()
    }
}

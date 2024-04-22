//
//  AsyncArchitectureApp.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import SwiftUI

@main
struct AsyncArchitectureApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: appDelegate.viewModel)
        }
    }
}

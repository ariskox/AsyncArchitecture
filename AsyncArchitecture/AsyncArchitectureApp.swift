//
//  AsyncArchitectureApp.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import SwiftUI
import SwiftData

@main
struct AsyncArchitectureApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(viewModel: appDelegate.viewModel)
            }
        }
        .modelContainer(sharedModelContainer)
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

}

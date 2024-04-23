//
//  ContentView.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import SwiftUI
import SwiftUINavigation
import CasePaths

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.networkMonitor.isConnected ? "Connected" : "Not connected")

            if viewModel.isLoading {
                ProgressView()
            } else {
                EmptyView()
            }

            Text(viewModel.statusText)

            Button(action: {
                Task {
                    try await viewModel.fetch()
                }
            }) {
                Text("Fetch")
            }

            Button(action: {
                viewModel.gotoNextPage()
            }) {
                Text("Go to Next page")
            }

        }
        .navigationTitle("Main screen")
        .padding()
        .navigationDestination(unwrapping: self.$viewModel.destination.detail) { $viewModel in
            NavigationLazyView(
                ContentDetailView(viewModel: viewModel)
            )
        }
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel())
}



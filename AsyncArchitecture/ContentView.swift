//
//  ContentView.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.networkMonitor.isConnected ? "Connected" : "Not connected")
            if viewModel.isLoading {
                ProgressView()
            } else {
                EmptyView()
            }

            Button(action: {
                Task {
                    try await viewModel.fetch()
                }
            }) {
                Text("Fetch")
            }

            Button(action: {
                Task {
                    try await viewModel.changeName()
                }
            }) {
                Text("Change name")
            }

            Button(action: {
                viewModel.changeNameByAsyncChange()
            }) {
                Text("Change name")
            }
            Button(action: {
                viewModel.changeActor()
            }) {
                Text("Change by actor")
            }

            Button(action: {
                viewModel.gotoNextPage()
            }) {
                Text("Go to details")
            }

        }
        .padding()
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel())
}



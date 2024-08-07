//
//  ContentDetailView.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import SwiftUI

struct ContentDetailView: View {
    @State var viewModel: ContentDetailViewModel

    var body: some View {
        List {
            ForEach(viewModel.persons) {
                Text($0.name)
            }
        }
        .navigationTitle("Detail screen")
    }
}

#Preview {
    let persons = [
        Person(
            id: "1",
            name: "Aris",
            surname: "Test"
        )
    ]

    return ContentDetailView(
        viewModel: ContentDetailViewModel(
            persons: persons
       )
    )
}

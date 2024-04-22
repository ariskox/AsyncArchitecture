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
        VStack {
            Text(viewModel.name)
        }
        .navigationTitle("Detail screen")
    }
}

#Preview {
    ContentDetailView(
        viewModel: ContentDetailViewModel(
            person: Person(
                name: "Aris",
                surname: "Test"
            )
       )
    )
}

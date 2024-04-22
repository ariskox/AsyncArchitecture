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
        Text(viewModel.name)
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

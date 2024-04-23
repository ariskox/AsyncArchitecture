//
//  ContentDetailViewModel.swift
//  AsyncArchitecture
//
//  Created by Aris Koxaras on 22/4/24.
//

import Foundation

@MainActor
@Observable
class ContentDetailViewModel {
    var persons: LazyArray<PersonDTO, Person>

    init(persons: inout LazyArray<PersonDTO, Person>) {
        self.persons = persons
    }
}

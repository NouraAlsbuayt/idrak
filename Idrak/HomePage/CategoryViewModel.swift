//
//  CategoryViewModel.swift
//  Idrak2
//
//  Created by Noura Alsbuayt on 09/06/1447 AH.
//
import SwiftUI
import Combine


final class CategoryViewModel: ObservableObject {
        @Published var hyperSelected: Bool = false
        @Published var focusSelected: Bool = false
        @Published var distractionSelected: Bool = false

        var anySelected: Bool {
            hyperSelected || focusSelected || distractionSelected
        }
    


}


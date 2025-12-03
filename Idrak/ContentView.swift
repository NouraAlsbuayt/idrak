//
//  ContentView.swift
//  Idrak2
//
//  Created by Noura Alsbuayt on 09/06/1447 AH.
//

import SwiftUI

struct ContentView: View {
    @StateObject var categoryVM = CategoryViewModel()

    var body: some View {
        NavigationStack {
            HomePageView(viewModel: categoryVM)
        }
    }
}


#Preview {
    ContentView()
}

//
//  RootView.swift
//  Idrak2
//
//  Created by Noura Alsbuayt on 09/06/1447 AH.
//

import SwiftUI
struct RootView: View {
    @StateObject private var viewModel = SplashViewModel()
    @StateObject private var ViewModel2 = CategoryViewModel()


    var body: some View {
        Group {
            if viewModel.showSplash {
                SplashView(viewModel: viewModel)
                    .transition(.opacity)
            } else {
                NavigationStack {
                    HomePageView(viewModel: ViewModel2)
                        .transition(.opacity)
                }
            }
        }
    }
}

#Preview {
    RootView()
}

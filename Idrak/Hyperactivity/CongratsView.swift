//
//  CongratsView.swift
//  Idrak2
//
//  Created by Noura Alsbuayt on 11/06/1447 AH.
//

import SwiftUI

struct CongratsView: View {
    @ObservedObject var viewModel: HyperactivityViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color("IdrakBackground")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                CurvedShape(color: Color("IdrakBlue"))
                    .frame(height: 250)
                    .ignoresSafeArea(edges: .top)

                Spacer()
            }

            VStack(spacing: 16) {
                VStack(spacing: 16) {
                    Text("Nice job! Your thinking is\ngetting faster and clearer")
                        .font(.system(size: 20, weight: .medium))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 25)


                    Image("celebrationBlue")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 360)
                        .padding(.bottom,10)

                }
                .frame(maxWidth: .infinity)

                Divider()

                HStack(spacing: 0) {
                    Button {
                        viewModel.continueToNextStep()
                    } label: {
                        Text("Continue")
                            .frame(maxWidth: .infinity, maxHeight: 44)
                            .foregroundColor(.black)
                    }

                    Divider()

                    NavigationLink {
                        HomePageView(viewModel: CategoryViewModel())
                    } label: {
                        Text("Done")
                            .frame(maxWidth: .infinity, maxHeight: 44)
                            .foregroundColor(.black)

                    }
                }
            }
            .frame(width: 340 , height: 550)
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 10)
            .padding(.bottom, 60)
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    NavigationStack {
        CongratsView(viewModel: HyperactivityViewModel())
    }
}


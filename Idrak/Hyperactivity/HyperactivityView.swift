//
//  HyperactivityView.swift
//  Idrak2
//

import SwiftUI

struct CurvedShape: View {
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                
                path.move(to: CGPoint(x: 0, y: height * 0.8))
                path.addQuadCurve(
                    to: CGPoint(x: width, y: height * 0.8),
                    control: CGPoint(x: width / 2, y: height * 1.0)
                )
                path.addLine(to: CGPoint(x: width, y: 0))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.closeSubpath()
            }
            .fill(color)
        }
    }
}


struct HyperactivityView: View {
    @StateObject private var viewModel = HyperactivityViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color("IdrakBackground")
                .ignoresSafeArea()

            VStack(spacing: 0) {

                ZStack(alignment: .bottom) {

                    CurvedShape(color: Color("IdrakBlue"))
                        .frame(height: 250)
                        .ignoresSafeArea(edges: .top)

                    Text(viewModel.currentStep.instruction)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 42)
                        .padding(.vertical, 28)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .white.opacity(0.12),
                                radius: 8, x: 0, y: 9)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 20)
                }
                .frame(height: 230)
                .overlay(alignment: .topLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Home Page")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .padding(8)
                    }
                    .padding(.top)
                    .padding(.leading, 14)
                }
                .padding(.bottom, 56)

                Text(viewModel.formattedTime)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color("IdrakBlue"))
                    .padding(.bottom, 40)

                Image(viewModel.currentStep.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 260)

                Spacer()

                HStack {
                    Spacer()
                    Button {
                        viewModel.skip()
                    } label: {
                        HStack(spacing: 4) {
                            
                            Text("Next")
                                .foregroundColor(.black)
                                .font(.system(size: 14, weight: .medium))
                            Image(systemName: "chevron.right")
                                .foregroundColor(.black)

                                                    }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(Color.idrakBackground)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1),
                                radius: 4, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }

            NavigationLink(
                destination: CongratsView(viewModel: viewModel),
                isActive: $viewModel.showCongrats
            ) {
                EmptyView()
            }
            .hidden()
        }
        .onAppear {
            viewModel.start()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        HyperactivityView()
    }
}

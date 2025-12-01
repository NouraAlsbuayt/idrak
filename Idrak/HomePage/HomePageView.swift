import SwiftUI

struct HomePageView: View {
    @ObservedObject var viewModel: CategoryViewModel
    
    var body: some View {
        ZStack {
                Color("IdrakBackground")
                    .ignoresSafeArea()
                
                VStack {
                    Text("Hi")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(Color("IdrakBlue"))
                        .padding(.top, 60)
                        .padding(.horizontal, 32)
                    
                    Spacer().frame(height: 40)
                    
                    Text("What do you like to do today?")
                        .foregroundColor(Color("IdrakBlue"))
                        .font(.system(size: 24, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 32)
                    
                    Spacer().frame(height: 40)
                    
                    CategoryView(
                        hyperSelected: $viewModel.hyperSelected,
                        focusSelected: $viewModel.focusSelected,
                        distractionSelected: $viewModel.distractionSelected
                    )
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    NavigationLink {
                        destinationView
                    } label: {
                        Text("Start Now !")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color("IdrakBlue"))
                            .cornerRadius(18)
                            .opacity(viewModel.anySelected ? 1.0 : 0.4)
                    }
                    .padding(.horizontal, 40)
                    .disabled(!viewModel.anySelected)
                }
            }
        }
    
        @ViewBuilder
        private var destinationView: some View {
            if viewModel.hyperSelected {
                //        DistractionView()
            } else if viewModel.focusSelected {
                //        FocusView()
            } else if viewModel.distractionSelected {
                DistractionView()
            } else {
                EmptyView()
            }
        }
        
    }
#Preview {
    HomePageView(viewModel: CategoryViewModel())
}

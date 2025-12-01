//
//  SplashScre.swift
//  Idrak2
//
//  Created by Noura Alsbuayt on 09/06/1447 AH.
//

import SwiftUI

struct SplashView : View {

   @ObservedObject var viewModel: SplashViewModel

    var body: some View {
        
        ZStack{
            
            Color("IdrakBackground")
                .ignoresSafeArea()
            
            VStack{
                
                VStack{
                    Text("Welcome To")
                        .font(.system(size:50 , weight: .bold ))
                        .foregroundColor(Color("IdrakBlue"))
                    Text("Idrak")
                        .font(.system(size:30 , weight: .semibold))
                        .italic()
                        .foregroundColor(Color("IdrakBlue"))
                    
                }
                

                Image("MainImage")
                    .resizable()
                    .scaledToFit()
                    .frame(height:600)
                    .padding(.bottom, -400)
                
                
            }
        }
        .onAppear{
            viewModel.startSplashTimer()
        }
       
        
        
    }
}



#Preview {
    SplashView(viewModel: SplashViewModel())
}

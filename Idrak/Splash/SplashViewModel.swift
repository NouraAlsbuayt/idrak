//
//  SplashViewModel.swift
//  Idrak2
//
//  Created by Noura Alsbuayt on 09/06/1447 AH.
//

import SwiftUI
import Combine

final class SplashViewModel: ObservableObject{
    
    
    @Published var showSplash : Bool = true
    
    func startSplashTimer(){
        DispatchQueue.main.asyncAfter(deadline: .now()+2){
            withAnimation{
                self.showSplash = false
            }
        }
    }
    
    
}

//
//  BubbleView.swift
//  Idrak2
//
//  Created by Noura Alsbuayt on 09/06/1447 AH.
//

import SwiftUI

struct BubbleView: View {
    
    
    let color:Color
    let title: String
    let systemIcone: String
    let isSelected: Bool
    let action: ()-> Void
    
    
    
    var body: some View{
        
        Button(action: action){
            ZStack{
                Circle()
                    .fill(
                        isSelected
                        ? color.opacity(0.8)
                        :color.opacity(0.25)
                        
                    )
                    .frame(width: 180 , height: 180)
                
                
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 110 ,height: 110)
                    .overlay(
                        VStack{
                            Image(systemName: systemIcone)
                                .font(.system(size: 26 , weight: .semibold))
                                .foregroundColor(color)
                            
                            Text(title)
                                .font(.system(size: 16,weight: .semibold))
                                .foregroundColor(color)
                        }
                    )
                
            }
        }
        .buttonStyle(.plain)
        
    }
    
    
    
}




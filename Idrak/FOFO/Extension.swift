//
//  Extension.swift
//  Idrak
//
//  Created by Afnan hassan on 16/06/1447 AH.
//

import SwiftUI

extension Color {
    static let customBackground = Color(red: 0xF4/255, green: 0xF2/255, blue: 0xEC/255)
    static let customGreen = Color(red: 0x41/255, green: 0x7B/255, blue: 0x5A/255)

    // Optional aliases to match usages elsewhere
    static let IdrakBackground = Color("IdrakBackground")
}

struct SuccessPopUp: View {
    var body: some View {
        // Use the defined background colors
        Color("color1")
        Color("IdrakBackground")
            .ignoresSafeArea()

        VStack {
            Text("Nice ! You did a great job")
                .font(.headline)
                .foregroundColor(.black)
                .padding(.top, 25)
            
            VStack {
                ZStack {
                    ForEach(0..<10) { _ in
                        Circle()
                            .fill(Color(hue: Double.random(in: 0...1), saturation: 0.8, brightness: 0.9))
                            .frame(width: CGFloat.random(in: 5...15), height: CGFloat.random(in: 5...15))
                            .offset(x: CGFloat.random(in: -100...100), y: CGFloat.random(in: -100...100))
                            .opacity(0.7)
                    }
                    
                    Image("Image 1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 170, height: 250)
                }
            }
            .padding(.vertical, 20)
            
            Divider()
                .padding(.horizontal, 0)
            
            HStack(spacing: 0) {
                Button("Continue") {
                    print("Continue tapped")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .foregroundColor(.black)
                
                Divider()
                    .frame(height: 50)
                
                Button("Done") {
                    print("Done tapped")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .foregroundColor(.black)
            }
        }
        .frame(width: 300)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

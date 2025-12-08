//
//  start.swift
//  Idrak
//
//  Created by Afnan hassan on 16/06/1447 AH.
//

import SwiftUI

struct start: View {
    var body: some View {
        ZStack {
            // الخلفية الأساسية باللون البيج الفاتح
            Color.customBackground
                .ignoresSafeArea()

            VStack {
                // الجزء الأخضر المنحني في الأعلى
                ZStack {
                    Color("IdrakBackground").ignoresSafeArea()
                    
                    VStack(spacing: 0) {
                        // الهيدر المنحني
                        BreathingHeaderShape_NiceJob(curveDepth: 0.22)
                            .fill(Color("coler1"))
                            .frame(height: 220)
                            .ignoresSafeArea(edges: .top)
                        
                        Spacer()
                    }
                }
            }
            
            VStack {
                Spacer() // يدفع المحتوى للأسفل قليلاً
                
                VStack(spacing: 10) {
                    Text("Start Task")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("will give you some Techniques")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // زر البداية
                    Button(action: {
                        // هنا يتم وضع منطق الانتقال للصفحة التالية (مثل Count1)
                        print("Start Button Tapped")
                    }) {
                        Text("START")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .stroke(Color.black, lineWidth: 2)
                            )
                    }
                    .padding(.top, 40)
                }
                .frame(maxHeight: .infinity)
                
                Spacer()
            }
        }
    }
}

#Preview {
    start()
}

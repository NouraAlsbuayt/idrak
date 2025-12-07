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
            Color.customBackground.edgesIgnoringSafeArea(.all)

            
            VStack {
                // الجزء الأخضر المنحني في الأعلى
                CurvedShape(color: .customGreen)
                    .frame(height: 200)
                    .ignoresSafeArea(edges: .top)
                
                Spacer()
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

// شكل مخصص لإنشاء المنحنى العلوي
struct CurvedShape: View {
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                
                path.move(to: CGPoint(x: 0, y: height * 0.8)) // تبدأ من المنتصف الأيسر
                path.addQuadCurve(
                    to: CGPoint(x: width, y: height * 0.8), // تنتهي في المنتصف الأيمن
                    control: CGPoint(x: width / 2, y: height * 1) // نقطة التحكم لإنشاء الانحناء
                )
                path.addLine(to: CGPoint(x: width, y: 0))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.closeSubpath()
            }
            .fill(color)
        }
    }
}
#Preview {
    start()
}

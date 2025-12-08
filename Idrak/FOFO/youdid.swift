//
//  youdid.swift
//  Idrak
//
//  Created by Afnan hassan on 16/06/1447 AH.
//

import SwiftUI

// شكل الهيدر المنحني محليًا لتوحيد الستايل
struct BreathingHeaderShape_NiceJob: Shape {
    var curveDepth: CGFloat = 0.22
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: width, y: 0))
        let y = height * (1.0 - curveDepth)
        path.addLine(to: CGPoint(x: width, y: y))
        path.addQuadCurve(
            to: CGPoint(x: 0, y: y),
            control: CGPoint(x: width / 2, y: height * (1.0 + curveDepth * 0.2))
        )
        path.addLine(to: .zero)
        path.closeSubpath()
        return path
    }
}

// شاشة "You Did" الأساسية التي تستخدم الشكل أعلاه
struct youdid: View {
    // اسم الصورة داخل الأصول (غير مستخدم هنا، اتركه إذا ستحتاجه لاحقًا)
    private let imageName = "Image 1"
    
    var body: some View {
        ZStack {
            Color("IdrakBackground").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // الهيدر المنحني
                BreathingHeaderShape_NiceJob(curveDepth: 0.22)
                    .fill(Color("Coler1")) // تأكد من صحة اسم اللون في الأصول
                    .frame(height: 220)
                    .ignoresSafeArea(edges: .top)
                
                Spacer(minLength: 0)
            }
            
            // مثال لمحتوى أمامي بسيط
            VStack {
                Spacer()
                Text("Nice job! Your thinking is getting faster and clearer")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 9)
                    .padding(.horizontal, 32)
                Spacer()
            }
        }
    }
}

#Preview {
    youdid()
}

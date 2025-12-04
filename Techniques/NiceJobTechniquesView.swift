//
//  NiceJobTechniquesView.swift
//  Idrak
//
//  Created by Noura Faiz Alfaiz on 03/12/2025.
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

struct NiceJobTechniquesView: View {
    var onContinue: (() -> Void)?
    var onDone: (() -> Void)?
    @Environment(\.dismiss) private var dismiss
    
    // اسم الصورة داخل الأصول
    private let imageName = "NiceJobDistracted"
    
    var body: some View {
        ZStack {
            Color("IdrakBackground").ignoresSafeArea()
            
            VStack(spacing: 0) {
                // الهيدر المنحني
                BreathingHeaderShape_NiceJob(curveDepth: 0.22)
                    .fill(Color("IdrakTeal"))
                    .frame(height: 220)
                    .ignoresSafeArea(edges: .top)
                    // أزلنا البادينغ السفلي حتى نسمح للكارد بالاقتراب/التداخل
                    //.padding(.bottom, 12)
                
                // نترك Spacer لاحقاً، الكارد سنرفعه للأعلى عبر offset
                Spacer(minLength: 0)
            }
            
            // البطاقة الرئيسية (مرفوعة للأعلى لتتداخل مع الهيدر)
            VStack(spacing: 0) {
                // العنوان
                Text("Nice job! Your thinking is getting faster and clearer")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black) // لون أسود حسب الطلب
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                
                // الصورة
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 320, maxHeight: 280)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                
                // فاصل علوي للشريط السفلي
                Divider()
                
                // الشريط السفلي للأزرار (Continue / Done)
                HStack(spacing: 0) {
                    Button {
                        onContinue?()
                    } label: {
                        Text("Continue")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, minHeight: 48)
                    }
                    
                    // فاصل عمودي بين الزرين
                    Rectangle()
                        .fill(Color.black.opacity(0.12))
                        .frame(width: 1, height: 48)
                    
                    Button {
                        onDone?() ?? dismiss()
                    } label: {
                        Text("Done")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, minHeight: 48)
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 8)
            .padding(.horizontal, 16)
            // هنا نرفع الكارد للأعلى للتداخل
            .offset(y: -24) // غيّرها إلى 0 للملاصقة، أو -32/-40 لتداخل أكبر
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview("Nice Job (Simple Card)") {
    NavigationStack {
        NiceJobTechniquesView(
            onContinue: {},
            onDone: {}
        )
    }
}

//
//  InfinityView.swift
//  Idrak
//
//  Created by Noura Faiz Alfaiz on 03/12/2025.
//

import SwiftUI

// محليًا هنا: شكل الهيدر المنحني لتجنب الاعتماد على ملفات أخرى
struct BreathingHeaderShape: Shape {
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

// صفحة الإنفينيتي بنفس لاياوت BreathingPageView
struct InfinityPageView: View {
    var onNext: (() -> Void)?
    @Environment(\.dismiss) private var dismiss
    @State private var showNiceJob: Bool = false
    @State private var goToBall: Bool = false // حالة دفع Ball
    
    var body: some View {
        ZStack {
            Color("IdrakBackground")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // هيدر منحني
                ZStack(alignment: .bottom) {
                    BreathingHeaderShape(curveDepth: 0.22)
                        .fill(Color("IdrakTeal"))
                        .frame(height: 220)
                        .ignoresSafeArea(edges: .top)
                    
                    // بطاقة التعليمات
                    HStack(alignment: .center, spacing: 12) {
                        // أيقونتان متداخلتان (أصفر + أخضر) مثل الصورة
                        ZStack {
                            Image("InfinityIconYellow")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .offset(x: 8) // الأصفر يمين قليلًا
                            Image("InfinityIconGreen")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .offset(x: -6) // الأخضر يسار قليلًا
                        }
                        .frame(width: 44, height: 44)
                        
                        Text("Rotate your device and slowly trace the dotted line")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.12),
                            radius: 8, x: 0, y: 9)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                }
                .frame(height: 210)
                .overlay(alignment: .topLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Exit")
                            .font(.title2)
                            .foregroundColor(.white) // أبيض
                            .padding(8)
                    }
                    .padding(.top)
                    .padding(.leading, 14)
                }
                .padding(.bottom, 40)
                
                // صورة المسار المنقّط في الوسط
                GeometryReader { proxy in
                    let minSide = min(proxy.size.width, proxy.size.height)
                    let maxWidth = minSide * 0.78  // نترك حواف مريحة
                    Image("InfinityDotted")
                        .resizable()
                        .scaledToFit()
                        .frame(width: maxWidth)
                        .shadow(color: .black.opacity(0.10), radius: 6, x: 0, y: 4)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                
                Spacer()
                
                // زر Next أسفل يمين (النص والسهم باللون الأخضر)
                HStack {
                    Spacer()
                    Button {
                        showNiceJob = true
                    } label: {
                        HStack(spacing: 4) {
                            Text("Next")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color("IdrakTeal"))
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color("IdrakTeal"))
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1),
                                radius: 4, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            
            // Infinity → NiceJob
            NavigationLink(isActive: $showNiceJob) {
                NiceJobTechniquesView(
                    onContinue: {
                        // Continue → Ball
                        goToBall = true
                    },
                    onDone: {
                        dismiss()
                    }
                )
            } label: {
                EmptyView()
            }
            .hidden()
        }
        // وجهة Ball باستخدام navigationDestination
        .navigationDestination(isPresented: $goToBall) {
            BallPageView()
        }
        .navigationBarBackButtonHidden(true) // إخفاء سهم الرجوع الافتراضي
    }
}

#Preview("Infinity Page") {
    NavigationStack {
        InfinityPageView()
    }
}

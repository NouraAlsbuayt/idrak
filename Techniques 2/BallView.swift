//
//  BallView.swift
//  Idrak
//
//  Created by Noura Faiz Alfaiz on 03/12/2025.
//

import SwiftUI

// شكل الهيدر المنحني (محليًا هنا لتجنّب الاعتماد على ملفات أخرى)
struct BreathingHeaderShape_Ball: Shape {
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

// صفحة مؤقتة لعرض "Nice job!"
struct NiceJobTempView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            Color("IdrakBackground").ignoresSafeArea()
            VStack(spacing: 16) {
                Text("Nice job!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color("IdrakBlue"))
                Text("You reached the end of the line.")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.secondary)
                Button("Back") { dismiss() }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
            .padding()
        }
    }
}

// صفحة الكرة
struct BallPageView: View {
    var onNext: (() -> Void)?
    @Environment(\.dismiss) private var dismiss
    
    // حالة الكرة: موقعها داخل القسم الأوسط
    @State private var ballCenter: CGPoint = .zero
    @State private var started: Bool = false
    @State private var showNiceJob: Bool = false
    @State private var shakeOffset: CGFloat = 0 // لاهتزاز بسيط
    
    // تتبع بدء المسار من الأسفل وعلى الخط
    @State private var startedOnLineFromBottom: Bool = false
    
    var body: some View {
        ZStack {
            Color("IdrakBackground")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // هيدر منحني
                ZStack(alignment: .bottom) {
                    BreathingHeaderShape_Ball(curveDepth: 0.22)
                        .fill(Color("IdrakTeal"))
                        .frame(height: 220)
                        .ignoresSafeArea(edges: .top)
                    
                    // بطاقة التعليمات مع أيقونتين متداخلتين
                    HStack(alignment: .center, spacing: 12) {
                        ZStack {
                            Image("Yellowball")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                                .offset(x: -6)
                            Image("Greenball")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                                .offset(x: 8)
                        }
                        .frame(width: 44, height: 44)
                        
                        Text("Try passing the ball along the line")
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
                
                // القسم الأوسط: خط رأسي طويل + الكرة تتحرك بحرية
                GeometryReader { proxy in
                    let availableW = proxy.size.width
                    let availableH = proxy.size.height
                    
                    // خصائص الخط
                    let lineWidth: CGFloat = 8
                    let corner: CGFloat = lineWidth / 2
                    let lineHeight = max(availableH * 0.72, 320)
                    let lineX = availableW / 2
                    let lineTopY = (availableH - lineHeight) / 2
                    let lineBottomY = lineTopY + lineHeight
                    
                    // خصائص الكرة
                    let ballSize: CGFloat = 64
                    let hitToleranceX: CGFloat = 18 // سماح جانبي
                    let finishToleranceY: CGFloat = 28 // سماح عند القمة
                    let bottomToleranceY: CGFloat = ballSize * 0.5 + 18 // أسفل
                    
                    // وظائف مساعدة كإغلاقات
                    let isOnLine: (CGFloat, CGFloat) -> Bool = { x, y in
                        abs(x - lineX) <= (lineWidth / 2 + hitToleranceX)
                        && y >= lineTopY && y <= lineBottomY
                    }
                    let nearBottomOnLine: (CGFloat, CGFloat) -> Bool = { x, y in
                        isOnLine(x, y) && abs(y - lineBottomY) <= bottomToleranceY
                    }
                    let reachedTop: (CGFloat, CGFloat) -> Bool = { x, y in
                        isOnLine(x, y) && abs(y - lineTopY) <= finishToleranceY
                    }
                    
                    ZStack {
                        // الخط
                        RoundedRectangle(cornerRadius: corner, style: .continuous)
                            .fill(Color("IdrakBlue"))
                            .frame(width: lineWidth, height: lineHeight)
                            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 4)
                            .position(x: lineX, y: availableH / 2)
                        
                        // الكرة
                        Image("Mainball")
                            .resizable()
                            .scaledToFit()
                            .frame(width: ballSize, height: ballSize)
                            .shadow(color: .black.opacity(0.18), radius: 6, x: 0, y: 4)
                            .position(ballCenter == .zero
                                      ? CGPoint(x: lineX + 100, y: lineBottomY - ballSize * 0.5)
                                      : ballCenter)
                            .offset(x: shakeOffset)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        // حركة حرة داخل الحدود
                                        let newX = min(max(value.location.x, ballSize/2), availableW - ballSize/2)
                                        let newY = min(max(value.location.y, ballSize/2), availableH - ballSize/2)
                                        ballCenter = CGPoint(x: newX, y: newY)
                                        
                                        // تفعيل البدء من الأسفل إذا لامسنا أسفل الخط
                                        if nearBottomOnLine(ballCenter.x, ballCenter.y) {
                                            startedOnLineFromBottom = true
                                        }
                                        
                                        // إلغاء البدء إذا خرجنا بعيدًا عن الخط
                                        if startedOnLineFromBottom && !isOnLine(ballCenter.x, ballCenter.y) {
                                            startedOnLineFromBottom = false
                                        }
                                        
                                        // إذا بدأنا من الأسفل وبقينا على الخط ووصلنا القمة أثناء السحب -> انتقل مباشرة
                                        if startedOnLineFromBottom && reachedTop(ballCenter.x, ballCenter.y) {
                                            showNiceJob = true
                                        }
                                    }
                                    .onEnded { _ in
                                        // إذا لم نصل أثناء السحب، نتحقق آخر مرة
                                        if startedOnLineFromBottom && reachedTop(ballCenter.x, ballCenter.y) {
                                            showNiceJob = true
                                        } else if !isOnLine(ballCenter.x, ballCenter.y) {
                                            // رجّة بسيطة للتنبيه
                                            withAnimation(.spring(response: 0.25, dampingFraction: 0.35)) {
                                                shakeOffset = 10
                                            }
                                            withAnimation(.spring(response: 0.25, dampingFraction: 0.35).delay(0.05)) {
                                                shakeOffset = -10
                                            }
                                            withAnimation(.spring(response: 0.25, dampingFraction: 0.6).delay(0.1)) {
                                                shakeOffset = 0
                                            }
                                        }
                                        // إعادة التهيئة للمحاولة القادمة
                                        startedOnLineFromBottom = false
                                    }
                            )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onAppear {
                        // تهيئة موضع ابتدائي مرة واحدة إذا لم يتم تعيينه
                        if ballCenter == .zero {
                            ballCenter = CGPoint(x: lineX + 100, y: lineBottomY - ballSize * 0.5)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // تمت إزالة صف زر Next بالكامل حسب الطلب
            }
            // NavigationLink مخفي للانتقال عند إكمال السحب
            NavigationLink(isActive: $showNiceJob) {
                NiceJobTechniquesView(
                    onContinue: {
                        // مؤقتًا نرجع خطوة؛ عدّلي لاحقًا حسب المطلوب
                        dismiss()
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
        .onChange(of: showNiceJob) { wasActive, isActive in
            if wasActive == true && isActive == false {
                ballCenter = .zero
                shakeOffset = 0
                startedOnLineFromBottom = false
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview("Ball Page") {
    NavigationStack {
        BallPageView()
    }
}

//
//  write.swift
//  Idrak
//
//  Created by Afnan hassan on 16/06/1447 AH.
//

import SwiftUI

struct Write: View {
    @Binding var path: NavigationPath // لتمرير مسار التنقل
    
    var body: some View {
        ZStack {
            // الخلفية تغطي الشاشة بالكامل
            Color.customBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // الشكل العلوي المنحني يغطي أعلى الشاشة
                CurvedShape(color: .customGreen)
                    .frame(height: 370) // ارتفاع أكبر قليلًا
                    .offset(y: 38)      // رفع الشكل للأعلى لتجاوز حافة الالتقاء
                    .clipped()          // قص أي رسم خارج الإطار
                    .ignoresSafeArea(edges: .top)
                    . offset(y: -50)

                    .drawingGroup()     // تحسين الدمج لمنع ظهور خطوط دقيقة
                
                Spacer()
            }
            
            VStack {
                // مربع النص العلوي
                GeometryReader { proxy in
                    let containerWidth = proxy.size.width
                    VStack {
                        Text("Write down everything on your mind on a piece of paper for 2-5 minutes")
                            .font(.system(size: 20, weight: .semibold))
                        
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 24)
                            .background(Color.white)
                            .cornerRadius(30)
                            .frame(maxWidth: min(420, containerWidth * 0.9), alignment: .center)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                .frame(height: 200)
                .padding(.top, 150)
                .padding(.top, 100)
                Spacer()
                
                // الصورة (شخص يكتب)
                VStack {
                    ZStack {
                        Image("Image 2")
                            .font(.system(size: 50))
                            .offset(y: -90)
                        
                        // Use a concrete shape instead of RotatedShape with an existential
                        Rectangle()
                            .fill(Color.black)
                            .frame(width: 5, height: 20)
                            .rotationEffect(.degrees(45))
                            .offset(x: 60, y: 55)
                    }
                }
                
                
                // زر/نص الانتقال (NEXT)
                HStack {
                    Spacer()
                    Button(action: {
                        // هنا ننتقل إلى صفحة Pomodoro الأولى
                        path.append(AppScreen.pomodoro25)
                    }) {
                        Text("NEXT >")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(.customGreen)
                            .padding(.trailing, 20)
                            .padding(.bottom, 20)
                    }
                }
            }
        }
    }
}
#Preview {
    write()
}

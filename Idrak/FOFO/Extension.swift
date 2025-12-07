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
}
import SwiftUI

struct SuccessPopUp: View {
    // يمكنك استخدام متغير Binding لتحديد ما إذا كانت النافذة مفتوحة أم لا
    // @Binding var isPresented: Bool
    
    // (سنفترض وجود الألوان Extensions كما في الأكواد السابقة)
    
    var body: some View {
        Color.customBackground
            .ignoresSafeArea()
        Color.customBackground.edgesIgnoringSafeArea(.all)

        // الشكل الخارجي للنافذة المنبثقة
        VStack {
            // النص العلوي
            Text("Nice ! You did a great job")
                .font(.headline)
                .foregroundColor(.black)
                .padding(.top, 25)
            
            // الصورة التوضيحية في منتصف الشيت
            VStack {
                ZStack {
                    // يمكن الإبقاء على القصاصات الملوّنة كخلفية احتفالية
                    ForEach(0..<10) { _ in
                        Circle()
                            .fill(Color(hue: Double.random(in: 0...1), saturation: 0.8, brightness: 0.9))
                            .frame(width: CGFloat.random(in: 5...15), height: CGFloat.random(in: 5...15))
                            .offset(x: CGFloat.random(in: -100...100), y: CGFloat.random(in: -100...100))
                            .opacity(0.7)
                    }
                    
                    // الصورة المطلوبة في المنتصف
                    Image("Image 1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 170, height: 250)
                }
            }
            .padding(.vertical, 20)
            
            // الخط الفاصل
            Divider()
                .padding(.horizontal, 0) // ليمتد على عرض النافذة
            
            // أزرار التحكم في الأسفل
            HStack(spacing: 0) {
                // زر Continue
                Button("Continue") {
                    // منطق الاستمرار/العودة للعمل
                    print("Continue tapped")
                    // isPresented = false
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .foregroundColor(.black)
                
                // فاصل رأسي بين الأزرار
                Divider()
                    .frame(height: 50)
                
                // زر Done
                Button("Done") {
                    // منطق الإنهاء الكامل / العودة للصفحة الرئيسية
                    print("Done tapped")
                    // isPresented = false
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .foregroundColor(.black)
            }
        }
        .frame(width: 300) // تحديد عرض النافذة المنبثقة
        .background(Color.white) // الخلفية بيضاء للبطاقة المنبثقة
        .cornerRadius(20) // حواف مستديرة للبطاقة
        .shadow(radius: 10) // ظل خفيف لجعلها تبدو منبثقة
    }
}





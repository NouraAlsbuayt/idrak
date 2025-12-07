//
//  youdid.swift
//  Idrak
//
//  Created by Afnan hassan on 16/06/1447 AH.
//

import SwiftUI

struct YouDid: View {
    @Binding var path: NavigationPath
    @State private var showingSuccessPopUp = true // لتحديد حالة ظهور النافذة

    var body: some View {
        ZStack {
            // 1. الخلفية والشكل الأساسي (كود YouDid القديم)
            VStack {
                Color.customBackground.edgesIgnoringSafeArea(.all)
                CurvedShape(color: .customGreen)
                    .frame(height: 400) // لتغطية النصف العلوي كما في الصورة الجديدة
                    .edgesIgnoringSafeArea(.top)
                Spacer()
            }

            // 2. المحتوى الرئيسي لصفحة YouDid (إذا كان هناك محتوى خلف النافذة)
            VStack {
                // يمكنك وضع محتوى خفيف هنا أو تركه فارغًا
            }
            
            // 3. النافذة المنبثقة (تظهر في مقدمة الـ ZStack)
            if showingSuccessPopUp {
                Color.black.opacity(0.4) // خلفية شبه شفافة لتعتيم ما خلف النافذة
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        // يمكن إغلاق النافذة بالنقر على الخلفية (اختياري)
                    }
                
                SuccessPopUp() // عرض النافذة نفسها
                    .transition(.opacity) // إضافة تأثير ظهور لطيف
            }
        }
    }
}

#Preview {
    youdid()
}

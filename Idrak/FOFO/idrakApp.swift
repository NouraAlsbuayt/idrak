//
//  idrakApp.swift
//  Idrak
//
//  Created by Afnan hassan on 16/06/1447 AH.
//

import SwiftUI

struct CountViewTemplate: View {
    let countNumber: Int
    
    var body: some View {
        ZStack {
            // الخلفية الأساسية باللون البيج الفاتح
            Color("IdrakBackground").ignoresSafeArea()

            
            VStack {
                // الجزء الأخضر المنحني في الأعلى
                CurvedShape(color: Color("color1"))
                    .frame(height: 170) // ارتفاع أقل من شاشة start
                    .edgesIgnoringSafeArea(.top)
                
                Spacer()
            }
            
            VStack {
                // مربع النص في الأعلى
                VStack {
                    Text("Count from 1 to 3 and start")
                        .font(.system(size: 22, weight: .semibold)) // تكبير الخط
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding( 28) // زياده الطول للمستطيل الأبيض
                        .background(Color.white)
                        .cornerRadius(10)
                }
                .padding(.top, 70) // يضعها تحت المنحنى الأخضر قليلاً
                
                Spacer()
                
                // الدائرة التي تحمل رقم العد
                ZStack {
                    Circle()
                        .fill(Color.color1)
                        .frame(width: 150, height: 150)
                    
                    Text("\(countNumber)")
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                // زر/نص الانتقال (NEXT)
                HStack {
                    Spacer()
                    Text("NEXT")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.customGreen)
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    Text("›")
                    font(.headline)
                    .baselineOffset(0)
                }
            }
        }
    }
}

//
//  pom.swift
//  Idrak
//
//  Created by Afnan hassan on 16/06/1447 AH.
//

import SwiftUI

struct Pom1: View {
    @Binding var path: NavigationPath // لتمرير مسار التنقل
    let timerDuration: Int // المدة بالدقائق (25 أو 5)
    let title: String // عنوان الصفحة "Pomodoro Techniques"
    let nextScreen: AppScreen? // الشاشة التالية بعد انتهاء المؤقت أو الضغط على NEXT
    
    // متغير حالة للمؤقت
    @State private var remainingTime: Int
    @State private var timerIsRunning = false
    @State private var timer: Timer? = nil
    
    init(path: Binding<NavigationPath>, timerDuration: Int, title: String, nextScreen: AppScreen?) {
        self._path = path
        self.timerDuration = timerDuration
        self.title = title
        self.nextScreen = nextScreen
        self._remainingTime = State(initialValue: timerDuration * 60) // تحويل الدقائق لثواني
    }

    var body: some View {
        ZStack {
            // الخلفية الأساسية باللون البيج الفاتح
            Color.customBackground
                .ignoresSafeArea()
            Color.customBackground.edgesIgnoringSafeArea(.all)

            VStack {
                // الجزء الأخضر المنحني في الأعلى
                CurvedShape(color: .color1)
                    .frame(height: 180)
                    .ignoresSafeArea(edges: .top)
                
                Spacer()
            }
            
            VStack(spacing: 40) {
                // مربع العنوان
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                    .frame(maxWidth: .infinity)
                    .background(Color.customBackground)
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                    .offset(y: 70)
                
                Spacer()
                
                // عرض المؤقت
                VStack {
                    Text(timeString(from: remainingTime))
                        .font(.system(size: 80, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 340, height: 150)
                        .background(Color.color1)
                        .cornerRadius(20)
                    
                    // أزرار التحكم بالمؤقت
                    HStack(spacing: 30) {
                        Button(action: { toggleTimer() }) {
                            Image(systemName: timerIsRunning ? "pause.fill" : "play.fill")
                                .font(.title2)
                                .foregroundColor(.color1)
                        }
                        Button(action: { resetTimer() }) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.title2)
                                .foregroundColor(.customGreen)
                        }
                        Button(action: { skipTimer() }) {
                            Image(systemName: "forward.fill")
                                .font(.title2)
                                .foregroundColor(.color1)
                        }
                    }
                    .padding(.top, 20)
                }
                
                Spacer()
                
                // زر/نص الانتقال (NEXT)
                HStack {
                    Spacer()
                    Button(action: {
                        stopTimer() // إيقاف المؤقت عند الانتقال
                        if let next = nextScreen {
                            path.append(next)
                        } else {
                            // إذا كانت الشاشة الأخيرة
                            print("Pomodoro sequence finished!")
                        }
                    }) {
                        Text("NEXT >")
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundColor(.color1)
                            .padding(.trailing, 20)
                            .padding(.bottom, 20)
                    }
                }
            }
        }
        .onAppear(perform: startTimer)   // بدء المؤقت عند ظهور الصفحة
        .onDisappear(perform: stopTimer) // إيقاف المؤقت عند مغادرة الصفحة
    }
    
    // تحويل الثواني إلى تنسيق MM:SS
    func timeString(from totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // بدء المؤقت
    func startTimer() {
        if !timerIsRunning && remainingTime > 0 {
            timerIsRunning = true
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if remainingTime > 0 {
                    remainingTime -= 1
                } else {
                    stopTimer()
                    // يمكن إضافة منطق للانتقال التلقائي هنا
                    print("Timer finished!")
                }
            }
        }
    }
    
    // إيقاف المؤقت
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerIsRunning = false
    }
    
    // تبديل حالة المؤقت (تشغيل/إيقاف مؤقت)
    func toggleTimer() {
        if timerIsRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    // إعادة تعيين المؤقت
    func resetTimer() {
        stopTimer()
        remainingTime = timerDuration * 60
        startTimer() // يمكن بدء التشغيل تلقائياً أو تركه متوقفاً
    }
    
    // تخطي المؤقت (إنهاؤه فوراً)
    func skipTimer() {
        remainingTime = 0
        stopTimer()
        // يمكن إضافة منطق الانتقال التلقائي هنا إذا لزم الأمر
    }
}

#Preview {
    // معاينة تجريبية بربط مسار تنقّل محلي
    StatefulPreviewWrapper(NavigationPath()) { path in
        Pom1(
            path: path,
            timerDuration: 25,
            title: "Pomodoro Techniques",
            nextScreen: .pomodoro5
        )
    }
}

// أداة بسيطة لتوفير Binding في المعاينة
struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        _value = State(initialValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}

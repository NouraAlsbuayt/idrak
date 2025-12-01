//
//  Untitled.swift
//  Idrak
//
//  Created by Lama Alsuhabani on 10/06/1447 AH.
//
import SwiftUI

// =============================================
// === 0. SHARED COMPONENTS AND WIDGETS ===
// =============================================

// --- 0.0 HomePageView (للبدء) ---
struct HomePage1View: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("🏠 الرئيسية")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                
                NavigationLink(destination: CategoryQuizView()) {
                    Text("ابدأ الاختبار")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("الشاشة الرئيسية")
            // تم تطبيق تغيير لون الخلفية الافتراضي إذا كان موجوداً
            // .background(Color("pageColor").edgesIgnoringSafeArea(.all))
        }
    }
}

// --- 0.1 QuizHeaderView (الهيدر المشترك) - مُحدَّث لزر "Main Page" ---
struct QuizHeaderView: View {
    @Environment(\.dismiss) var dismiss
    // ✅ إضافة Binding للتحكم في التنقل للصفحة الرئيسية
    @Binding var navigateToMainPage: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            Color("HColor")
                .frame(height: 150)

            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 0))
                path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: 50))
                path.addQuadCurve(to: CGPoint(x: 0, y: 50),
                                  control: CGPoint(x: UIScreen.main.bounds.width / 2, y: 100))
                path.closeSubpath()
            }
            .fill(Color("HColor"))
            .frame(height: 100)
            .offset(y: 50)

            HStack {
                // 1. زر "Main Page" (أعلى اليسار)
                Button(action: {
                    dismiss()
                    navigateToMainPage = true
                }) {
                    Text("Main Page")
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(20)
                }
                .padding(.leading, 30)

                Spacer()
                
                // 2. زر الإغلاق (X)
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding(8)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Circle())
                }
                .padding(.trailing, 30)
            }
            .offset(y: -95)
        }
        .edgesIgnoringSafeArea(.top)
        .frame(height: 150)
    }
}

// --- 0.2 AnswerButton (زر الإجابة لـ CategoryQuizView) ---
struct AnswerButton: View {
    let title: String
    let isSelected: Bool
    let isCorrect: Bool
    let onTap: (String) -> Void

    var buttonColor: Color {
        guard isSelected else { return Color.white }
        let correctGreen = Color(red: 0.5, green: 0.8, blue: 0.5)
        let incorrectRed = Color.red.opacity(0.6)
        return isCorrect ? correctGreen : incorrectRed
    }
    var textColor: Color { isSelected ? .white : .black }

    var body: some View {
        Button(action: { onTap(title) }) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity)
                .padding()
                .background(buttonColor)
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(isSelected ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1))
                .animation(.easeIn(duration: 0.1), value: isSelected)
        }.disabled(isSelected)
    }
}

// --- 0.3 FeedbackButton (زر الصح/الخطأ لصفحات الألوان) ---
struct FeedbackButton<Answer: Equatable>: View {
    let iconName: String
    let iconColor: Color
    let buttonAnswer: Answer
    @Binding var selectedAnswer: Answer?
    let feedbackColor: Color
    let onTap: () -> Void

    var isCurrentButtonSelected: Bool { selectedAnswer == buttonAnswer }
    var isQuizAnswered: Bool { selectedAnswer != nil }

    var body: some View {
        Button(action: onTap) {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(iconColor)
                .frame(width: 120, height: 120)
                .background(isCurrentButtonSelected ? feedbackColor : .clear)
                .cornerRadius(15)
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }
        .disabled(isQuizAnswered)
        .animation(.easeIn(duration: 0.1), value: feedbackColor)
    }
}

// --- 0.4 PromptCard (بطاقة السؤال) ---
struct PromptCard: View {
    enum IconSet { case text, palette, shape }
    let iconSet: IconSet
    let prompt: String

    @ViewBuilder
    var iconView: some View {
        switch iconSet {
        case .text:
            ZStack {
                Circle().frame(width: 40, height: 40).foregroundColor(.white.opacity(0.8))
                    .overlay(Text("C").font(.title2).bold().foregroundColor(.orange))
                Circle().frame(width: 20, height: 20).foregroundColor(.blue)
                    .overlay(Text("A").font(.caption2).bold().foregroundColor(.white))
                    .offset(x: -10, y: -10)
            }
            .padding(.trailing, 10)
        case .palette:
            Image(systemName: "paintpalette.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(Color(red: 0.4, green: 0.7, blue: 0.6))
                .padding(.trailing, 10)
        case .shape:
            Image(systemName: "heart.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.pink)
                .padding(.trailing, 10)
        }
    }

    var body: some View {
        HStack(alignment: .center) {
            iconView
            Text(prompt)
                .font(.headline)
                .multilineTextAlignment(.leading)
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5, x: 0, y: 3)
        .padding(.horizontal, 32)
    }
}

// --- 0.5 FinalWhitePageView (صفحة النهاية البيضاء) - تم تحديث الخلفية ---
struct FinalWhitePageView: View {
    var body: some View {
        ZStack {
            Color("pageColor").edgesIgnoringSafeArea(.all)
            VStack {
                Text("🎉 نهاية التسلسل! 🎉")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("تم الانتهاء")
    }
}

// --- 0.6 NumberButton (الزر المخصص) ---
struct NumberButton: View {
    let number: Int
    let isTappedCorrectly: Bool
    let onTap: () -> Void
    
    @State private var temporaryWrongTap: Bool = false

    var backgroundColor: Color {
        if isTappedCorrectly {
            return .green.opacity(0.7)
        } else if temporaryWrongTap {
            return .gray.opacity(0.7)
        }
        return Color.white
    }

    var body: some View {
        Button(action: {
            onTap()
            if !isTappedCorrectly {
                temporaryWrongTap = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    temporaryWrongTap = false
                }
            }
        }) {
            Text("\(number)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .frame(width: 80, height: 80)
                .background(backgroundColor)
                .cornerRadius(12)
                .shadow(radius: 2, x: 0, y: 1)
        }
        .disabled(isTappedCorrectly)
        .animation(.easeOut(duration: 0.1), value: temporaryWrongTap)
        .animation(.easeOut(duration: 0.1), value: isTappedCorrectly)
    }
}

// --- 0.7 Skip Button Shared View - تم تحديث النص من "SKIP" إلى "Next" ---
struct SkipButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                // ✅ التغيير هنا
                Text("Next").font(.callout).fontWeight(.bold)
                Image(systemName: "chevron.right")
            }
            .foregroundColor(.gray)
            .padding(.horizontal, 32)
        }
    }
}

// 🌟 --- 0.8 IntermediateSuccessView (شاشة النجاح المؤقتة) - تم تحديث الخلفية --- 🌟
struct IntermediateSuccessView: View {
    
    @Environment(\.dismiss) var dismissView
    
    @Binding var navigateToDone: Bool
    
    @Binding var navigateToNextQuiz: Bool
    
    let showContinue: Bool

    var body: some View {
        ZStack(alignment: .top) {
            Color("pageColor").edgesIgnoringSafeArea(.all)
            // بما أن هذا View يظهر كـ fullScreenCover، لا يمكنه استخدام زر "Main Page" في الهيدر، لأن زر الإغلاق X هو المسؤول عن إخفائه.
            QuizHeaderView(navigateToMainPage: .constant(false)) // استخدام قيمة ثابتة
            
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    Text("Nice job! Your thinking is getting faster and clearer")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding(.top, 30)

                    Image("Image1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .foregroundColor(Color(red: 1.0, green: 0.8, blue: 0.0))
                        .padding(.bottom, 20)
                    
                    Divider()

                    HStack {
                        // 1. زر DONE
                        Button("Done") {
                            dismissView()
                            navigateToDone = true
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        
                        if showContinue {
                            Divider()
                                .frame(height: 50)
                            
                            // 2. زر CONTINUE
                            Button("Continue") {
                                dismissView()
                                navigateToNextQuiz = true
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                        }
                    }
                    .frame(height: 50)
                }
                .frame(maxWidth: 350)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 5, x: 0, y: 3)
                .padding(.horizontal, 32)
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}


// =============================================
// === 1. QUIZ VIEWS (6 PAGES) - مُحدَّثة بالخلفية وزر Main Page ===
// =============================================

// --- 1.1 CategoryQuizView (الصفحة الأولى: التصنيف) ---
struct CategoryQuizView: View {
    let correctAnswer: String = "Spoon"
    let options: [String] = ["Car", "Bus", "Train", "Spoon"]
    @State private var selectedAnswer: String? = nil
    @State private var isSuccess: Bool = false
    @State private var navigateToNextQuiz: Bool = false
    @State private var navigateToDone: Bool = false
    @State private var navigateToMainPage: Bool = false // ✅ إضافة

    var body: some View {
        ZStack(alignment: .top) {
            Color("pageColor").edgesIgnoringSafeArea(.all)
            QuizHeaderView(navigateToMainPage: $navigateToMainPage) // ✅ تحديث
            VStack {
                PromptCard(iconSet: .text, prompt: "Tap on the word that belongs to the different category")
                    .padding(.top, 70)
                Spacer()
                VStack(spacing: 16) {
                    ForEach(options, id: \.self) { option in
                        AnswerButton(title: option, isSelected: selectedAnswer == option, isCorrect: option == correctAnswer, onTap: handleAnswerSelection)
                    }
                }
                .padding(.horizontal, 32)
                Spacer()
                SkipButton(action: { isSuccess = true })
                    .padding(.bottom, 10)
            }
            .navigationBarHidden(true)

            .fullScreenCover(isPresented: $isSuccess) {
                IntermediateSuccessView(
                    navigateToDone: $navigateToDone,
                    navigateToNextQuiz: $navigateToNextQuiz,
                    showContinue: true
                )
            }

            NavigationLink(destination: ColorMatchQuizView(), isActive: $navigateToNextQuiz) { EmptyView() }
            NavigationLink(destination: FinalWhitePageView(), isActive: $navigateToDone) { EmptyView() }
            NavigationLink(destination: HomePage1View(), isActive: $navigateToMainPage) { EmptyView() } // ✅ إضافة
        }
    }
    
    func handleAnswerSelection(selectedOption: String) {
        guard selectedAnswer == nil else { return }
        selectedAnswer = selectedOption
        if selectedOption == correctAnswer {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                isSuccess = true
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                selectedAnswer = nil
            }
        }
    }
}


// --- 1.2 ColorMatchQuizView (الصفحة الثانية: لا تطابق) ---
struct ColorMatchQuizView: View {
    enum Answer { case match, mismatch }
    let currentQuestion = (word: "Yellow", wordColor: Color.blue, correctAnswer: Answer.mismatch)
    @State private var selectedAnswer: Answer? = nil
    @State private var feedbackColor: Color = .clear
    @State private var isSuccess: Bool = false
    @State private var navigateToNextQuiz: Bool = false
    @State private var navigateToDone: Bool = false
    @State private var navigateToMainPage: Bool = false // ✅ إضافة

    var body: some View {
        ZStack(alignment: .top) {
            Color("pageColor").edgesIgnoringSafeArea(.all)
            QuizHeaderView(navigateToMainPage: $navigateToMainPage) // ✅ تحديث
            VStack {
                PromptCard(iconSet: .palette, prompt: "Does the color match the word?")
                    .padding(.top, 70)
                Spacer()
                // ✅ محتوى السؤال (الكلمة الملونة)
                Text(currentQuestion.word)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(currentQuestion.wordColor)
                    .frame(maxWidth: .infinity).padding(30)
                    .background(Color.white).cornerRadius(15).shadow(radius: 5, x: 0, y: 3).padding(.horizontal, 32)
                Spacer()
                // ✅ أزرار الإجابة (صح/خطأ)
                HStack(spacing: 30) {
                    FeedbackButton(iconName: "xmark", iconColor: .red, buttonAnswer: Answer.mismatch, selectedAnswer: $selectedAnswer, feedbackColor: feedbackColor, onTap: { handleAnswerSelection(.mismatch) })
                    FeedbackButton(iconName: "checkmark", iconColor: .green, buttonAnswer: Answer.match, selectedAnswer: $selectedAnswer, feedbackColor: feedbackColor, onTap: { handleAnswerSelection(.match) })
                }
                .padding(.horizontal, 40)
                Spacer()
                SkipButton(action: { isSuccess = true }).padding(.bottom, 10)
            }
            .navigationBarHidden(true)

            .fullScreenCover(isPresented: $isSuccess) {
                IntermediateSuccessView(navigateToDone: $navigateToDone, navigateToNextQuiz: $navigateToNextQuiz, showContinue: true)
            }

            NavigationLink(destination: NewColorMatchQuizView(), isActive: $navigateToNextQuiz) { EmptyView() }
            NavigationLink(destination: FinalWhitePageView(), isActive: $navigateToDone) { EmptyView() }
            NavigationLink(destination: HomePage1View(), isActive: $navigateToMainPage) { EmptyView() } // ✅ إضافة
        }
    }
    
    func handleAnswerSelection(_ answer: Answer) {
        guard selectedAnswer == nil else { return }
        selectedAnswer = answer
        let isCorrect = (answer == currentQuestion.correctAnswer)
        feedbackColor = isCorrect ? .green.opacity(0.6) : .gray.opacity(0.6)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if isCorrect { isSuccess = true } else { selectedAnswer = nil; feedbackColor = .clear }
        }
    }
}


// --- 1.3 NewColorMatchQuizView (الصفحة الثالثة: تطابق صحيح) ---
struct NewColorMatchQuizView: View {
    enum Answer { case match, mismatch }
    let currentQuestion = (word: "Green", wordColor: Color.green, correctAnswer: Answer.match)
    @State private var selectedAnswer: Answer? = nil
    @State private var feedbackColor: Color = .clear
    @State private var isSuccess: Bool = false
    @State private var navigateToNextQuiz: Bool = false
    @State private var navigateToDone: Bool = false
    @State private var navigateToMainPage: Bool = false // ✅ إضافة

    var body: some View {
        ZStack(alignment: .top) {
            Color("pageColor").edgesIgnoringSafeArea(.all)
            QuizHeaderView(navigateToMainPage: $navigateToMainPage) // ✅ تحديث
            VStack {
                PromptCard(iconSet: .palette, prompt: "Does the color match the word?").padding(.top, 70)
                Spacer()
                // ✅ محتوى السؤال (الكلمة الملونة)
                Text(currentQuestion.word)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(currentQuestion.wordColor)
                    .frame(maxWidth: .infinity).padding(30)
                    .background(Color.white).cornerRadius(15).shadow(radius: 5, x: 0, y: 3).padding(.horizontal, 32)
                Spacer()
                // ✅ أزرار الإجابة (صح/خطأ)
                HStack(spacing: 30) {
                    FeedbackButton(iconName: "xmark", iconColor: .red, buttonAnswer: Answer.mismatch, selectedAnswer: $selectedAnswer, feedbackColor: feedbackColor, onTap: { handleAnswerSelection(.mismatch) })
                    FeedbackButton(iconName: "checkmark", iconColor: .green, buttonAnswer: Answer.match, selectedAnswer: $selectedAnswer, feedbackColor: feedbackColor, onTap: { handleAnswerSelection(.match) })
                }
                .padding(.horizontal, 40)
                Spacer()
                SkipButton(action: { isSuccess = true }).padding(.bottom, 10)
            }
            .navigationBarHidden(true)
            
            .fullScreenCover(isPresented: $isSuccess) {
                IntermediateSuccessView(navigateToDone: $navigateToDone, navigateToNextQuiz: $navigateToNextQuiz, showContinue: true)
            }

            NavigationLink(destination: NumberThreeQuizView(), isActive: $navigateToNextQuiz) { EmptyView() }
            NavigationLink(destination: FinalWhitePageView(), isActive: $navigateToDone) { EmptyView() }
            NavigationLink(destination: HomePage1View(), isActive: $navigateToMainPage) { EmptyView() } // ✅ إضافة
        }
    }
    
    func handleAnswerSelection(_ answer: Answer) {
        guard selectedAnswer == nil else { return }
        selectedAnswer = answer
        let isCorrect = (answer == currentQuestion.correctAnswer)
        feedbackColor = isCorrect ? .green.opacity(0.6) : .gray.opacity(0.6)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if isCorrect { isSuccess = true } else { selectedAnswer = nil; feedbackColor = .clear }
        }
    }
}

// --- 1.4 NumberThreeQuizView (الصفحة الرابعة: اختبار الرقم 3) ---
struct NumberThreeQuizView: View {
    let allNumbers: [Int] = [83, 55, 667, 44, 163, 21, 98, 528, 70, 37, 33, 40]
    var correctNumbers: Set<Int> { Set(allNumbers.filter { String($0).contains("3") }) }
    
    @State private var selectedNumbers: Set<Int> = []
    @State private var isSuccess: Bool = false
    @State private var navigateToNextQuiz: Bool = false
    @State private var navigateToDone: Bool = false
    @State private var navigateToMainPage: Bool = false // ✅ إضافة
    
    // ✅ التصحيح: استخدام isSuperset للتأكد من اختيار جميع الأرقام الصحيحة
    var isQuizComplete: Bool { selectedNumbers.isSuperset(of: correctNumbers) }

    var body: some View {
        ZStack(alignment: .top) {
            Color("pageColor").edgesIgnoringSafeArea(.all)
            QuizHeaderView(navigateToMainPage: $navigateToMainPage) // ✅ تحديث
            VStack {
                PromptCard(iconSet: .text, prompt: "Tap on the number that appears 3")
                    .padding(.top, 70)
                Spacer()
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                    ForEach(allNumbers, id: \.self) { number in
                        NumberButton(number: number, isTappedCorrectly: selectedNumbers.contains(number) && correctNumbers.contains(number), onTap: { handleSelection(number) })
                    }
                }
                .padding(.horizontal, 20)
                Spacer()
                
                if isQuizComplete {
                    Text("✅ أحسنت! جميع الأرقام التي تحتوي على 3 تم اختياره")
                        .font(.headline).foregroundColor(.green).padding()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                isSuccess = true
                            }
                        }
                } else {
                    SkipButton(action: { isSuccess = true }).padding(.bottom, 10)
                }
            }
            .navigationBarHidden(true)

            .fullScreenCover(isPresented: $isSuccess) {
                IntermediateSuccessView(navigateToDone: $navigateToDone, navigateToNextQuiz: $navigateToNextQuiz, showContinue: true)
            }

            NavigationLink(destination: NumberQuizView(), isActive: $navigateToNextQuiz) { EmptyView() }
            NavigationLink(destination: FinalWhitePageView(), isActive: $navigateToDone) { EmptyView() }
            NavigationLink(destination: HomePage1View(), isActive: $navigateToMainPage) { EmptyView() } // ✅ إضافة
        }
    }
    
    func handleSelection(_ number: Int) {
        if String(number).contains("3") { selectedNumbers.insert(number) }
    }
}


// --- 1.5 NumberQuizView (الصفحة الخامسة: اختبار الترتيب التصاعدي) ---
struct NumberQuizView: View {
    
    let allNumbers: [Int] = [2, 8, 5, 11, 24, 16, 7]
    var correctOrder: [Int] { allNumbers.sorted() }
    
    @State private var selectedSequence: [Int] = []
    @State private var isSuccess: Bool = false
    @State private var navigateToNextQuiz: Bool = false
    @State private var navigateToDone: Bool = false
    @State private var navigateToMainPage: Bool = false // ✅ إضافة
    
    var expectedNextNumber: Int? {
        let nextIndex = selectedSequence.count
        return nextIndex < correctOrder.count ? correctOrder[nextIndex] : nil
    }
    
    var isQuizComplete: Bool { selectedSequence.count == correctOrder.count }

    var body: some View {
        ZStack(alignment: .top) {
            Color("pageColor").edgesIgnoringSafeArea(.all)
            QuizHeaderView(navigateToMainPage: $navigateToMainPage) // ✅ تحديث
            VStack {
                PromptCard(iconSet: .text, prompt: "Tap on the number in an ascending order")
                    .padding(.top, 70)
                Spacer()
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(allNumbers, id: \.self) { number in
                        NumberButton(number: number, isTappedCorrectly: selectedSequence.contains(number), onTap: { handleSelection(number) })
                    }
                }
                .padding(.horizontal, 20)
                Spacer()
                if isQuizComplete {
                    Text("✅ أحسنت! تم اختيار الأرقام بالترتيب التصاعدي الصحيح.")
                        .font(.headline).foregroundColor(.green).padding()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                isSuccess = true
                            }
                        }
                } else {
                    SkipButton(action: { isSuccess = true }).padding(.bottom, 10)
                }
            }
            .navigationBarHidden(true)

            .fullScreenCover(isPresented: $isSuccess) {
                IntermediateSuccessView(navigateToDone: $navigateToDone, navigateToNextQuiz: $navigateToNextQuiz, showContinue: true)
            }

            NavigationLink(destination: SumToTenQuizView(), isActive: $navigateToNextQuiz) { EmptyView() }
            NavigationLink(destination: FinalWhitePageView(), isActive: $navigateToDone) { EmptyView() }
            NavigationLink(destination: HomePage1View(), isActive: $navigateToMainPage) { EmptyView() } // ✅ إضافة
        }
    }
    
    func handleSelection(_ number: Int) {
        guard !selectedSequence.contains(number) else { return }
        if number == expectedNextNumber { selectedSequence.append(number) }
    }
}

// --- 1.6 SumToTenQuizView (الصفحة السادسة: مجموع 10) ---
struct SumToTenQuizView: View {
    
    let allNumbers: [Int] = [6, 5, 9, 2, 8, 4, 3, 6]
    @State private var selectedNumbers: [Int] = []
    @State private var isSuccess: Bool = false
    
    @State private var navigateToNextQuiz: Bool = false
    @State private var navigateToDone: Bool = false
    @State private var navigateToMainPage: Bool = false // ✅ إضافة

    var body: some View {
        ZStack(alignment: .top) {
            Color("pageColor").edgesIgnoringSafeArea(.all)
            QuizHeaderView(navigateToMainPage: $navigateToMainPage) // ✅ تحديث

            VStack {
                PromptCard(iconSet: .text, prompt: "Select two numbers that add up to 10")
                    .padding(.top, 70)

                Spacer()
                
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)], spacing: 20) {
                    
                    ForEach(allNumbers.indices, id: \.self) { index in
                        let number = allNumbers[index]
                        
                        NumberButton(
                            number: number,
                            isTappedCorrectly: isSuccess,
                            onTap: { handleSelection(number: number) }
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedNumbers.contains(number) && !isSuccess ? Color.orange : Color.clear, lineWidth: 2)
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()

                if isSuccess {
                    Text("✅ أحسنت! المجموع يساوي 10.")
                        .font(.headline).foregroundColor(.green).padding()
                } else {
                    SkipButton(action: { isSuccess = true }).padding(.bottom, 10)
                }
            }
            .navigationBarHidden(true)

            // اللغز الأخير: showContinue: false
            .fullScreenCover(isPresented: $isSuccess) {
                IntermediateSuccessView(
                    navigateToDone: $navigateToDone,
                    navigateToNextQuiz: $navigateToNextQuiz,
                    showContinue: false
                )
            }
            
            NavigationLink(destination: FinalWhitePageView(), isActive: $navigateToDone) { EmptyView() }
            NavigationLink(destination: HomePage1View(), isActive: $navigateToMainPage) { EmptyView() } // ✅ إضافة
        }
    }
    
    func handleSelection(number: Int) {
        guard !isSuccess else { return }
            
        if selectedNumbers.count < 2 && !selectedNumbers.contains(number) {
            selectedNumbers.append(number)
        } else if selectedNumbers.count == 2 {
            selectedNumbers.removeAll()
            selectedNumbers.append(number)
        }

        if selectedNumbers.count == 2 {
            if selectedNumbers.reduce(0, +) == 10 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isSuccess = true
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    selectedNumbers.removeAll()
                }
            }
        }
    }
}


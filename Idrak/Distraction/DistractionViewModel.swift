import SwiftUI
import Combine

struct ExerciseStep: Identifiable {
    let id = UUID()
    let instruction: String
    let imageName: String
    let duration: Int
}

final class DistractionViewModel: ObservableObject {

    @Published var steps: [ExerciseStep]
    @Published var currentIndex: Int = 0
    @Published var timeRemaining: Int

    private var timer: Timer?

    init() {
        // أول شيء نحط البيانات في متغير محلي بدون استخدام self
        let stepsData: [ExerciseStep] = [
            ExerciseStep(
                instruction: "Raise your arms and one of your legs.",
                imageName: "exercise1",
                duration: 50
            ),
            ExerciseStep(
                instruction: "Walk in a straight line.",
                imageName: "exercise2",
                duration: 50
            ),
            ExerciseStep(
                instruction: "Stand on one leg, lean your body forward, stretch your arms back, and lift the other leg behind you.",
                imageName: "exercise3",
                duration: 50
            )
        ]

        // بعدين نعيّن الخصائص من المتغير المحلي
        self.steps = stepsData
        self.timeRemaining = stepsData.first?.duration ?? 50
    }

    var currentStep: ExerciseStep {
        steps[currentIndex]
    }

    var formattedTime: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "0:%02d:%02d", minutes, seconds)
    }

    func start() {
           startTimerForCurrentStep()
       }

       private func startTimerForCurrentStep() {
           timer?.invalidate()
           timeRemaining = currentStep.duration

           timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
               guard let self else { return }
               if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.goToNextStep()
            }
        }
    }

    func skip() {
        goToNextStep()
    }

    private func goToNextStep() {
        if currentIndex < steps.count - 1 {
            currentIndex += 1
            startTimerForCurrentStep()
        } else {
            timer?.invalidate()
        }
    }

    deinit {
        timer?.invalidate()
    }
}

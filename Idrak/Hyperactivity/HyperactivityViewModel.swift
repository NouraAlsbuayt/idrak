//
//  HyperactivityViewModel.swift
//  Idrak2
//

import SwiftUI
import Combine

struct ExerciseStep: Identifiable {
    let id = UUID()
    let instruction: String
    let imageName: String
    let duration: Int
}

final class HyperactivityViewModel: ObservableObject {
    @Published var steps: [ExerciseStep]
    @Published var currentIndex: Int = 0
    @Published var timeRemaining: Int
    @Published var showCongrats: Bool = false    

    private var timer: Timer?

    init() {
        let stepsData: [ExerciseStep] = [
            ExerciseStep(
                instruction: "Raise your arms and one of your legs.",
                imageName: "exercise1",
                duration: 5
            ),
            ExerciseStep(
                instruction: "Walk in a straight line.",
                imageName: "exercise2",
                duration: 5
            ),
            ExerciseStep(
                instruction: "Stand on one leg, lean your body forward, stretch your arms back, and lift the other leg behind you.",
                imageName: "exercise3",
                duration: 5
            )
        ]

        self.steps = stepsData
        self.timeRemaining = stepsData.first?.duration ?? 5
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
                self.timer?.invalidate()
                self.showCongrats = true
            }
        }
    }

    func continueToNextStep() {
        showCongrats = false
        if currentIndex < steps.count - 1 {
            currentIndex += 1
            startTimerForCurrentStep()
        } else {
        }
    }

    func skip() {
        timer?.invalidate()
        if currentIndex < steps.count - 1 {
            currentIndex += 1
            startTimerForCurrentStep()
        } else {
            // آخر تمرين
        }
    }

    deinit {
        timer?.invalidate()
    }
}

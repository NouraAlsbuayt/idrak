
import SwiftUI

struct BreathingView: View {
    var body: some View {
        BreathingBubbleView(
            baseDiameter: 260,
            color: .cyan,
            background: LinearGradient(
                colors: [
                    Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0),
                    Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            inhale: 4,   // شهيق بطيء 4s
            hold: 2,     // هولد قصير 3s (تقدرين تغيّرينه لـ 2–4)
            exhale: 8    // زفير بطيء 8s
        )
    }
}

struct BreathingBubbleView: View {
    // Config
    let baseDiameter: CGFloat
    let color: Color
    let background: AnyShapeStyle
    let inhale: Double
    let hold: Double
    let exhale: Double

    // Animation state
    @State private var phase: Phase = .inhale
    @State private var scale: CGFloat = 0.75
    @State private var glowStrength: CGFloat = 0.6

    enum Phase { case inhale, hold, exhale }

    init(baseDiameter: CGFloat,
         color: Color,
         background: some ShapeStyle,
         inhale: Double,
         hold: Double,
         exhale: Double) {
        self.baseDiameter = baseDiameter
        self.color = color
        self.background = AnyShapeStyle(background)
        self.inhale = inhale
        self.hold = hold
        self.exhale = exhale
    }

    var body: some View {
        ZStack {
            // Background
            Rectangle()
                .fill(background)
                .ignoresSafeArea()

            // Ambient glow behind bubble
            RadialGradient(
                colors: [
                    color.opacity(0.34 * glowStrength),
                    color.opacity(0.06 * glowStrength),
                    .clear
                ],
                center: .center,
                startRadius: baseDiameter * 0.25,
                endRadius: baseDiameter * 2.0
            )
            .blur(radius: baseDiameter * 0.42)
            .scaleEffect(scale)

            // Bubble
            ZStack {
                // Outer soft glow ring
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                color.opacity(0.36 * glowStrength),
                                color.opacity(0.12 * glowStrength),
                                .clear
                            ],
                            center: .center,
                            startRadius: baseDiameter * 0.38,
                            endRadius: baseDiameter * 0.95
                        )
                    )
                    .blur(radius: baseDiameter * 0.2)

                // Main bubble with inner light
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                color.opacity(0.68),
                                color.opacity(0.44)
                            ],
                            center: .center,
                            startRadius: baseDiameter * 0.06,
                            endRadius: baseDiameter * 0.58
                        )
                    )
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        color.opacity(0.72),
                                        color.opacity(0.22)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                            .blur(radius: 0.6)
                    )
                    .shadow(color: color.opacity(0.45 * glowStrength),
                            radius: baseDiameter * 0.13, x: 0, y: 0)
                    .shadow(color: color.opacity(0.26 * glowStrength),
                            radius: baseDiameter * 0.30, x: 0, y: 0)
            }
            .frame(width: baseDiameter, height: baseDiameter)
            .scaleEffect(scale)
        }
        .task {
            await runBreathingLoop()
        }
    }

    // MARK: - Targets

    private func targetScale(for phase: Phase) -> CGFloat {
        switch phase {
        case .inhale: return 1.18   // يكبر بهدوء
        case .hold:   return 1.18   // ثابت
        case .exhale: return 0.75   // يصغر بهدوء
        }
    }

    private func targetGlow(for phase: Phase) -> CGFloat {
        switch phase {
        case .inhale: return 1.0
        case .hold:   return 0.95   // خفوت بسيط جدًا
        case .exhale: return 0.55
        }
    }

    // MARK: - Animation helpers

    private func ease(duration: Double) -> Animation {
        // منحنى ناعم جداً مناسب للتنفس على مدة طويلة
        .timingCurve(0.25, 0.10, 0.25, 1.0, duration: duration) // يشبه easeInOutSine لكن أهدأ
    }

    @MainActor
    private func animate(to newPhase: Phase, duration: Double) async {
        phase = newPhase
        withAnimation(ease(duration: duration)) {
            scale = targetScale(for: newPhase)
            glowStrength = targetGlow(for: newPhase)
        }
        try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
    }

    @MainActor
    private func runBreathingLoop() async {
        // ابدأ بحجم الزفير ليكون أول انتقال هو الشهيق البطيء (4s)
        scale = targetScale(for: .exhale)
        glowStrength = targetGlow(for: .exhale)

        while true {
            // 4s شهيق — تكبير تدريجي بطيء
            await animate(to: .inhale, duration: inhale)

            // هولد قصير (حجم ثابت، توهج يهدأ قليلًا فقط)
            withAnimation(ease(duration: hold)) {
                scale = targetScale(for: .hold)
                glowStrength = targetGlow(for: .hold)
            }
            try? await Task.sleep(nanoseconds: UInt64(hold * 1_000_000_000))

            // 8s زفير — تصغير تدريجي بطيء
            await animate(to: .exhale, duration: exhale)
        }
    }
}

#Preview {
    BreathingView()
}

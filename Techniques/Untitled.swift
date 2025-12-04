import SwiftUI

// 1) شكل الهيدر كـ Shape بدل View
struct Breathing: Shape {
    var curveDepth: CGFloat = 0.2
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        let y = height * (1.0 - curveDepth)
        path.addLine(to: CGPoint(x: width, y: y))
        path.addQuadCurve(
            to: CGPoint(x: 0, y: y),
            control: CGPoint(x: width / 2, y: height * (1.0 + curveDepth * 0.2))
        )
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.closeSubpath()
        return path
    }
}

struct ConcentricWavesIcon: View {
    var ringColor: Color = Color("IdrakBlue")
    var size: CGFloat = 44
    var body: some View {
        ZStack {
            Circle().fill(Color.white)
            Circle().stroke(ringColor.opacity(0.35), lineWidth: size * 0.18).blur(radius: 0.2)
            Circle().stroke(ringColor, lineWidth: size * 0.07).frame(width: size * 0.68, height: size * 0.68)
            Circle().stroke(ringColor.opacity(0.75), lineWidth: size * 0.14).frame(width: size * 0.42, height: size * 0.42)
        }
        .frame(width: size, height: size)
        .shadow(color: .black.opacity(0.06), radius: 2, x: 0, y: 1)
    }
}

struct BreathingBubbleView: View {
    let baseDiameter: CGFloat
    let color: Color
    let background: AnyShapeStyle
    let inhale: Double
    let hold: Double
    let exhale: Double

    @State private var phase: Phase = .inhale
    @State private var scale: CGFloat = 0.75
    @State private var glowStrength: CGFloat = 0.6

    enum Phase { case inhale, hold, exhale }

    init(baseDiameter: CGFloat = 260,
         color: Color = Color("IdrakBlue"),
         background: some ShapeStyle = Color.clear,
         inhale: Double = 4,
         hold: Double = 2,
         exhale: Double = 8) {
        self.baseDiameter = baseDiameter
        self.color = color
        self.background = AnyShapeStyle(background)
        self.inhale = inhale
        self.hold = hold
        self.exhale = exhale
    }

    var body: some View {
        ZStack {
            Rectangle().fill(background).ignoresSafeArea()
            RadialGradient(
                colors: [color.opacity(0.34 * glowStrength), color.opacity(0.06 * glowStrength), .clear],
                center: .center, startRadius: baseDiameter * 0.25, endRadius: baseDiameter * 2.0
            )
            .blur(radius: baseDiameter * 0.42)
            .scaleEffect(scale)

            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [color.opacity(0.36 * glowStrength), color.opacity(0.12 * glowStrength), .clear],
                            center: .center, startRadius: baseDiameter * 0.38, endRadius: baseDiameter * 0.95
                        )
                    )
                    .blur(radius: baseDiameter * 0.2)

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [color.opacity(0.68), color.opacity(0.44)],
                            center: .center, startRadius: baseDiameter * 0.06, endRadius: baseDiameter * 0.58
                        )
                    )
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(colors: [color.opacity(0.72), color.opacity(0.22)],
                                               startPoint: .topLeading, endPoint: .bottomTrailing),
                                lineWidth: 2
                            )
                            .blur(radius: 0.6)
                    )
                    .shadow(color: color.opacity(0.45 * glowStrength), radius: baseDiameter * 0.13, x: 0, y: 0)
                    .shadow(color: color.opacity(0.26 * glowStrength), radius: baseDiameter * 0.30, x: 0, y: 0)
            }
            .frame(width: baseDiameter, height: baseDiameter)
            .scaleEffect(scale)
        }
        .task { await runBreathingLoop() }
    }

    private func targetScale(for phase: Phase) -> CGFloat {
        switch phase { case .inhale, .hold: return 1.18; case .exhale: return 0.75 }
    }
    private func targetGlow(for phase: Phase) -> CGFloat {
        switch phase { case .inhale: return 1.0; case .hold: return 0.95; case .exhale: return 0.55 }
    }
    private func ease(duration: Double) -> Animation { .timingCurve(0.25, 0.10, 0.25, 1.0, duration: duration) }
    @MainActor private func animate(to newPhase: Phase, duration: Double) async {
        withAnimation(ease(duration: duration)) {
            scale = targetScale(for: newPhase)
            glowStrength = targetGlow(for: newPhase)
        }
        try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
    }
    @MainActor private func runBreathingLoop() async {
        scale = targetScale(for: .exhale)
        glowStrength = targetGlow(for: .exhale)
        while true {
            await animate(to: .inhale, duration: inhale)
            withAnimation(ease(duration: hold)) {
                scale = targetScale(for: .hold)
                glowStrength = targetGlow(for: .hold)
            }
            try? await Task.sleep(nanoseconds: UInt64(hold * 1_000_000_000))
            await animate(to: .exhale, duration: exhale)
        }
    }
}

// 4) صفحة Breathing
struct BreathingPageView: View {
    var onNext: (() -> Void)?
    @Environment(\.dismiss) private var dismiss
    @State private var showNiceJob: Bool = false
    @State private var goToInfinity: Bool = false // حالة دفع Infinity
    
    var body: some View {
        ZStack {
            Color("IdrakBackground").ignoresSafeArea()
            
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    Breathing(curveDepth: 0.22)
                        .fill(Color("IdrakTeal"))
                        .frame(height: 220)
                        .ignoresSafeArea(edges: .top)
                    
                    HStack(alignment: .center, spacing: 12) {
                        ConcentricWavesIcon(ringColor: Color("IdrakBlue"), size: 44)
                        Text("Inhale with the bubble as it grows, exhale as it shrinks")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 9)
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
                            .foregroundColor(.white)
                            .padding(8)
                    }
                    .padding(.top)
                    .padding(.leading, 14)
                }
                .padding(.bottom, 40)
                
                BreathingBubbleView(
                    baseDiameter: 260,
                    color: Color("IdrakBlue"),
                    background: LinearGradient(colors: [Color.clear, Color.clear],
                                               startPoint: .topLeading, endPoint: .bottomTrailing),
                    inhale: 4, hold: 2, exhale: 8
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer()
                
                // زر Next أسفل يمين (باللون الأخضر)
                HStack {
                    Spacer()
                    Button {
                        showNiceJob = true
                    } label: {
                        HStack(spacing: 4) {
                            Text("Next")
                                .foregroundColor(Color("IdrakTeal"))
                                .font(.system(size: 14, weight: .medium))
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color("IdrakTeal"))
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            
            // Breathing → NiceJob
            NavigationLink(isActive: $showNiceJob) {
                NiceJobTechniquesView(
                    onContinue: {
                        // عند الضغط Continue ندفع Infinity
                        goToInfinity = true
                    },
                    onDone: {
                        dismiss()
                    }
                )
            } label: { EmptyView() }
            .hidden()
        }
        // وجهة Infinity باستخدام navigationDestination
        .navigationDestination(isPresented: $goToInfinity) {
            InfinityPageView()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview("Breathing Page") {
    NavigationStack {
        BreathingPageView()
    }
}

//
//  HourDecoration.swift
//  WhatsAppWrapped
//
//  Slide 16: cada período do dia tem fundo, cor do horário e cena própria na base.
//  Madrugada/noite (16a): lua manteiga, estrelinhas piscando e 🦉 sobre noite.
//  Manhã (16b): sol coral com raios rosa e 🐓 sobre manteiga. Tarde (16c): sol se pondo e 🌇 sobre coral.
//

import SwiftUI

/// Visual de cada período do dia no slide de horário.
struct HourStyle {
    let backdrop: Backdrop
    /// Cor do horário em destaque ("23h47").
    let valueColor: Color
    /// "Você é do time da …".
    let teamName: String
    let emoji: String

    init(_ partOfDay: HourStats.PartOfDay) {
        switch partOfDay {
        case .lateNight:
            self.init(backdrop: .night, valueColor: .butter, teamName: "madrugada", emoji: "🦉")
        case .night:
            self.init(backdrop: .night, valueColor: .butter, teamName: "noite", emoji: "🦉")
        case .morning:
            self.init(backdrop: .butter, valueColor: .coralDeep, teamName: "manhã", emoji: "🐓")
        case .afternoon:
            self.init(backdrop: .coral, valueColor: .plum, teamName: "tarde", emoji: "🌇")
        }
    }

    private init(backdrop: Backdrop, valueColor: Color, teamName: String, emoji: String) {
        self.backdrop = backdrop
        self.valueColor = valueColor
        self.teamName = teamName
        self.emoji = emoji
    }
}

struct HourDecoration: View {
    let partOfDay: HourStats.PartOfDay

    /// Estrelinhas da madrugada: tamanho e centro no Figma.
    private static let stars: [(size: CGFloat, center: CGPoint)] = [
        (20, CGPoint(x: 50, y: 600)),
        (12, CGPoint(x: 96, y: 686)),
        (16, CGPoint(x: 338, y: 508)),
        (14, CGPoint(x: 67, y: 827)),
    ]

    var body: some View {
        ZStack {
            switch partOfDay {
            case .lateNight, .night:
                ConcentricDecoration(layers: [.init(image: .decoArcButter320, diameter: 280)], center: CGPoint(x: 310, y: 690))
                ForEach(Self.stars.indices, id: \.self) { index in
                    TwinklingStar(size: Self.stars[index].size, center: Self.stars[index].center, delay: Double(index) * 0.3)
                }
            case .morning:
                BurstDecoration(image: .decoSunRose, size: CGSize(width: 360, height: 360), center: CGPoint(x: 310, y: 690), startAngle: 0)
                ConcentricDecoration(layers: [.init(image: .decoArcCoral600, diameter: 280)], center: CGPoint(x: 310, y: 690))
            case .afternoon:
                ConcentricDecoration(layers: [.init(image: .decoArcButter320, diameter: 280)], center: CGPoint(x: 310, y: 810))
            }
            DecorationEmoji(emoji: HourStyle(partOfDay).emoji, size: 120, center: CGPoint(x: 292, y: 802))
        }
    }
}

/// Estrela creme que pisca devagar. Parada com "Reduzir movimento".
private struct TwinklingStar: View {
    let size: CGFloat
    let center: CGPoint
    let delay: Double

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isDimmed = false

    var body: some View {
        FigmaCanvas { scale in
            Image(.decoBurstCream)
                .resizable()
                .frame(width: scale.length(size * 0.975), height: scale.length(size))
                .opacity(isDimmed ? 0.3 : 1)
                .position(scale.point(center))
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 1.2).repeatForever().delay(delay)) { isDimmed = true }
        }
    }
}

#Preview {
    HStack(spacing: 0) {
        ForEach([HourStats.PartOfDay.lateNight, .morning, .afternoon], id: \.self) { part in
            ZStack {
                HourStyle(part).backdrop.color
                HourDecoration(partOfDay: part)
            }
        }
    }
    .ignoresSafeArea()
}

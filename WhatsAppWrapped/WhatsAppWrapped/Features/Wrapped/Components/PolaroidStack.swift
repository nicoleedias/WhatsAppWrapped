//
//  PolaroidStack.swift
//  WhatsAppWrapped
//
//  Slide 17d: três polaroides creme sobrepostas (área de 329×232), cada uma com uma "foto" colorida,
//  um emoji e o mês. Sobem 260 pt com pop e giram até a inclinação final, uma depois da outra.
//

import SwiftUI

struct PolaroidStack: View {
    struct Item: Hashable {
        let emoji: String
        /// "jan", "jul", "dez".
        let label: String
    }

    /// Área do Figma.
    private static let area = CGSize(width: 329, height: 232)
    /// Centro, inclinação inicial e final e cor da foto de cada polaroide.
    private static let placements: [(center: CGPoint, from: Double, to: Double, fill: Color)] = [
        (CGPoint(x: 67.19, y: 120.17), -16, 8, .butter),
        (CGPoint(x: 175.31, y: 80.39), 10, -5, .lilac),
        (CGPoint(x: 243.34, y: 114.65), -6, 3, .rose),
    ]

    let items: [Item]

    var body: some View {
        GeometryReader { geometry in
            let scale = geometry.size.width / Self.area.width
            ForEach(Array(zip(items.prefix(3), Self.placements).enumerated()), id: \.offset) { index, pair in
                PolaroidCard(item: pair.0, fill: pair.1.fill)
                    .dropIn(from: pair.1.from, to: pair.1.to, delay: 0.5 + Double(index) * 0.14)
                    .position(x: pair.1.center.x * scale, y: pair.1.center.y)
            }
        }
        .frame(height: Self.area.height)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(items.map(\.label).joined(separator: ", "))
    }
}

private struct PolaroidCard: View {
    let item: PolaroidStack.Item
    let fill: Color

    var body: some View {
        VStack(spacing: 6) {
            Text(item.emoji)
                .font(.system(size: 44))
                .frame(width: 128, height: 128)
                .background(fill, in: .rect(cornerRadius: 2))
            Text(item.label)
                .textStyle(.bodyS)
        }
        .foregroundStyle(.ink)
        .padding(.horizontal, 8)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(.cream, in: .rect(cornerRadius: 6))
        .shadow(color: .ink.opacity(0.18), radius: 8, y: 8)
    }
}

private extension View {
    /// Sobe 260 pt com pop girando de `from` até `to` graus. Com "Reduzir movimento", só aparece.
    func dropIn(from: Double, to: Double, delay: Double) -> some View {
        modifier(DropIn(from: from, to: to, delay: delay))
    }
}

private struct DropIn: ViewModifier {
    let from: Double
    let to: Double
    let delay: Double

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var hasLanded = false

    func body(content: Content) -> some View {
        let isSettled = hasLanded || reduceMotion
        content
            .rotationEffect(.degrees(isSettled ? to : from))
            .offset(y: isSettled ? 0 : 260)
            .opacity(hasLanded ? 1 : 0)
            .onAppear {
                withAnimation(Motion.pop.speed(0.8).delay(delay)) { hasLanded = true }
            }
    }
}

#Preview {
    PolaroidStack(items: [
        .init(emoji: "🌅", label: "jan"),
        .init(emoji: "🎂", label: "jul"),
        .init(emoji: "🐶", label: "dez"),
    ])
    .padding(32)
    .background(.coral)
}

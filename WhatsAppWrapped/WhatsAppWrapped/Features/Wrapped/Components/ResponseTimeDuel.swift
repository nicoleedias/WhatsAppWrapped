//
//  ResponseTimeDuel.swift
//  WhatsAppWrapped
//
//  Slide 14: quem responde mais rápido em cima, quem demora embaixo, separados por uma linha.
//  Enquanto o tempo de quem demora não aparece (14a–14c), o lugar dele é um balão "digitando…".
//  O tempo mais lento aparece em coral escuro (14d).
//

import SwiftUI

struct ResponseTimeDuel: View {
    struct Entry {
        /// "VOCÊ", "NICOLE", "MAIS RÁPIDA · BIA".
        let label: String
        /// "32min", "3h42min".
        let time: String
    }

    let fastest: Entry
    let slowest: Entry
    /// false mostra o "digitando…" no lugar do tempo mais lento.
    let isRevealed: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ResponseTimeRow(label: fastest.label, time: fastest.time)
            Rectangle()
                .frame(height: 1)
                .accessibilityHidden(true)
            ResponseTimeRow(label: slowest.label, time: isRevealed ? slowest.time : nil, isSlowest: true)
        }
    }
}

struct ResponseTimeRow: View {
    let label: String
    /// nil mostra o balão digitando.
    let time: String?
    var isSlowest = false

    var body: some View {
        VStack(alignment: .leading, spacing: time == nil ? 8 : 0) {
            Text(label)
                .textStyle(.label)
            if let time {
                Text(time)
                    .textStyle(.numberLarge, minimumScale: 0.5)
                    .foregroundStyle(isSlowest ? Color.coralDeep : .ink)
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
            } else {
                TypingBubble(style: .dark)
                    .frame(minHeight: 88, alignment: .leading)
                    .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .animation(Motion.pop, value: time)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    @Previewable @State var isRevealed = false

    ResponseTimeDuel(
        fastest: .init(label: "Você", time: "32min"),
        slowest: .init(label: "Nicole", time: "3h42min"),
        isRevealed: isRevealed
    )
    .padding(32)
    .background(.cream)
    .onTapGesture { isRevealed.toggle() }
}

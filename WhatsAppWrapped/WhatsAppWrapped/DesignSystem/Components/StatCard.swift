//
//  StatCard.swift
//  WhatsAppWrapped
//
//  Card de estatística do resumo final (grade 2×2): emoji, número em destaque e legenda.
//

import SwiftUI

struct StatCard: View {
    enum Tint {
        case rose, butter, coral, lilac

        var color: Color {
            switch self {
            case .rose: .rose
            case .butter: .butter
            case .coral: .coral
            case .lilac: .lilac
            }
        }
    }

    let emoji: String
    let value: String
    let caption: String
    let tint: Tint

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(emoji)
                .textStyle(.title)
                .accessibilityHidden(true)
            Text(value)
                .textStyle(.heading2)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(caption)
                .textStyle(.bodyS)
        }
        .foregroundStyle(.ink)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
        .background(tint.color, in: .rect(cornerRadius: 28))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    Grid(horizontalSpacing: 12, verticalSpacing: 12) {
        GridRow {
            StatCard(emoji: "😭", value: "1.365×", caption: "emoji #1", tint: .rose)
            StatCard(emoji: "😂", value: "2.847", caption: "risadas", tint: .butter)
        }
        GridRow {
            StatCard(emoji: "🔥", value: "95 dias", caption: "de sequência", tint: .coral)
            StatCard(emoji: "🦉", value: "23h47", caption: "horário de pico", tint: .lilac)
        }
    }
    .padding(32)
    .background(.plum)
}

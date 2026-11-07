//
//  SplitBar.swift
//  WhatsAppWrapped
//
//  Slide 17e: "quem manda mais" em uma barra dividida. Nome e total nas pontas; a parte de quem está
//  à esquerda é tinta e cresce da esquerda, o resto fica creme (4 pt de espaço entre as duas).
//

import SwiftUI

struct SplitBar: View {
    struct Side {
        /// "Você", "Rafa", "resto do grupo".
        let name: String
        let count: Int
    }

    let leading: Side
    let trailing: Side

    private var fraction: Double {
        let total = leading.count + trailing.count
        return total == 0 ? 0.5 : Double(leading.count) / Double(total)
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("\(leading.name) · \(leading.count.formatted())")
                Spacer()
                Text("\(trailing.name) · \(trailing.count.formatted())")
            }
            .textStyle(.bodySBold)

            GeometryReader { geometry in
                let available = geometry.size.width - 4
                HStack(spacing: 4) {
                    Capsule()
                        .fill(.ink)
                        .frame(width: available * fraction)
                        .barGrowth(delay: 1)
                    Capsule()
                        .fill(.cream)
                }
            }
            .frame(height: 12)
            .accessibilityHidden(true)
        }
        .foregroundStyle(.ink)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    SplitBar(leading: .init(name: "Você", count: 268), trailing: .init(name: "Nicole", count: 73))
        .padding(32)
        .background(.lime)
}

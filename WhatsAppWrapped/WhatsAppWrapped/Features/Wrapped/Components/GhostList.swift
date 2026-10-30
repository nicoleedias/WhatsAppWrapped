//
//  GhostList.swift
//  WhatsAppWrapped
//
//  Slide 20: quem quase nunca aparece no grupo. Cada linha tem o 👻 num círculo translúcido, o nome,
//  um detalhe ("só lê") e um número em rosa ("143 dias"), com uma linha creme entre as pessoas.
//

import SwiftUI

struct GhostList: View {
    struct Ghost: Hashable {
        let name: String
        /// "só reage 👍", "só lê".
        let detail: String
        /// "143 dias", "12 mensagens".
        let value: String
    }

    let ghosts: [Ghost]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(ghosts.enumerated()), id: \.element) { index, ghost in
                GhostRow(ghost: ghost)
                    .overlay(alignment: .top) {
                        if index > 0 { Rectangle().fill(.cream).frame(height: 1) }
                    }
                    .entrance(delay: 0.2 + Double(index) * Motion.cascadeStep)
            }
        }
    }
}

private struct GhostRow: View {
    let ghost: GhostList.Ghost

    var body: some View {
        HStack(spacing: 16) {
            Text("👻")
                .font(.system(size: 28))
                .frame(width: 56, height: 56)
                .background(Color.cream.opacity(0.15), in: .circle)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(ghost.name)
                    .textStyle(.title)
                    .lineLimit(1)
                Text(ghost.detail)
                    .textStyle(.bodyS)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(ghost.value)
                .textStyle(.rankValue)
                .foregroundStyle(.rose)
        }
        .foregroundStyle(.cream)
        .padding(.vertical, 16)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    GhostList(ghosts: [
        .init(name: "Lu", detail: "só reage 👍", value: "143 dias"),
        .init(name: "Caio", detail: "só lê", value: "87 dias"),
        .init(name: "Tânia", detail: "só manda áudio", value: "61 dias"),
    ])
    .padding(32)
    .background(.ink)
}

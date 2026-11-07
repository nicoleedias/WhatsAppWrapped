//
//  RetrospectiveCard.swift
//  WhatsAppWrapped
//
//  Cartão de uma conversa analisada (00a): foto(s), etiqueta "Individual · 2026", nome e o total de
//  mensagens, em formato de balão. Tocar abre o resumo; o ••• abre o menu de ações.
//

import SwiftUI

struct RetrospectiveCard: View {
    let card: RetrospectivesViewModel.Card
    let fill: Color
    let open: () -> Void
    let showActions: () -> Void

    /// Cores dos cartões em sequência, como na lista do Figma.
    static let fills: [Color] = [.coral, .butter, .lilac, .rose, .lime]

    var body: some View {
        HStack(spacing: 16) {
            Button(action: open) {
                HStack(spacing: 16) {
                    photos
                    VStack(alignment: .leading, spacing: 4) {
                        Text(card.tag)
                            .textStyle(.label)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.ink.opacity(0.1), in: .rect(cornerRadius: 10))
                        Text(card.title)
                            .textStyle(.title)
                            .lineLimit(2)
                        Text(card.highlight)
                            .textStyle(.bodyS)
                            .opacity(0.85)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .accessibilityHint("Abre o resumo")

            Button(action: showActions) {
                Text("•••")
                    .textStyle(TextStyle(size: 12, weight: .extraBold, tracking: 1.2, relativeTo: .caption))
                    .frame(width: 40, height: 40)
                    .background(Color.ink.opacity(0.1), in: .circle)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Ações de \(card.title)")
        }
        .foregroundStyle(.ink)
        .padding(20)
        .background(fill, in: BubbleShape(radius: 28, tail: .bottomLeading))
        // As fotos usam a cor do fundo na borda; aqui a borda é sempre creme.
        .environment(\.backdrop, .cream)
    }

    @ViewBuilder
    private var photos: some View {
        if card.isGroup {
            GroupPhotos(names: card.participants)
        } else {
            AvatarView(name: card.participants.first ?? card.title, size: .card)
        }
    }
}

/// Até duas fotos de 40 pt sobrepostas e um "+N" creme com o resto do grupo.
private struct GroupPhotos: View {
    let names: [String]

    private static let fills: [Color] = [.rose, .butter]
    private static let maxShown = 2

    private var shown: [String] { Array(names.prefix(Self.maxShown)) }
    private var hiddenCount: Int { names.count - shown.count }

    var body: some View {
        HStack(spacing: -14) {
            ForEach(Array(shown.enumerated()), id: \.offset) { index, name in
                AvatarView(name: name, fill: Self.fills[index % Self.fills.count])
                    .zIndex(Double(Self.maxShown - index))
            }
            if hiddenCount > 0 {
                Text("+\(hiddenCount)")
                    .textStyle(AvatarView.Size.small.textStyle, minimumScale: 0.5)
                    .frame(width: AvatarView.Size.small.rawValue, height: AvatarView.Size.small.rawValue)
                    .background(.cream, in: .circle)
                    .accessibilityLabel("mais \(hiddenCount) pessoas")
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    VStack(spacing: 12) {
        RetrospectiveCard(
            card: .init(id: UUID(), isGroup: false, tag: "Individual · 2026", title: "Nicole", highlight: "30.597 mensagens", participants: ["Nicole"]),
            fill: .coral, open: {}, showActions: {}
        )
        RetrospectiveCard(
            card: .init(id: UUID(), isGroup: true, tag: "Grupo · 2026", title: "Rolê de sexta", highlight: "84.210 mensagens", participants: ["Bia", "Rafa", "Lu", "Caio", "Tânia", "Nicole"]),
            fill: .lilac, open: {}, showActions: {}
        )
    }
    .padding(32)
    .background(.cream)
}

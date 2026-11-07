//
//  GhostsSlide.swift
//  WhatsAppWrapped
//
//  20: quem quase nunca aparece no grupo, sobre tinta com os círculos no topo.
//

import SwiftUI

struct GhostsSlide: StorySlide {
    static let label = "Grupo"
    static let phraseSlide: PhraseSlide? = .ghosts

    let ghosts: [GhostList.Ghost]

    var body: some View {
        ScreenContainer(backdrop: .ink) {
            ConcentricDecoration.ghosts
        } content: {
            SlideHeader()
            Text("Quem nunca aparece")
                .textStyle(.slideTitle)
                .accessibilityAddTraits(.isHeader)
                .entrance()
            GhostList(ghosts: ghosts)
            SlidePhraseBubble()
            Spacer(minLength: 0)
        }
        .slideFooter()
    }
}

#Preview {
    GhostsSlide(
        ghosts: [.init(name: "Lu", detail: "só lê", value: "0 mensagens"), .init(name: "Caio", detail: "quase não fala", value: "12 mensagens")]
    )
    .slidePreview(phrase: .init(emoji: "💨", text: "Está vivo? Manda um sinal de fumaça."))
}

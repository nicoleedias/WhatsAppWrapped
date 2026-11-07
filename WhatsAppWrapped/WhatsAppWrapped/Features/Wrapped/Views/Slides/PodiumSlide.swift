//
//  PodiumSlide.swift
//  WhatsAppWrapped
//
//  19: pódio de quem mais fala no grupo, sobre coral.
//

import SwiftUI

struct PodiumSlide: StorySlide {
    static let label = "Grupo"
    static let phraseSlide: PhraseSlide? = .podium

    let podium: [PersonCount]
    let displayName: (String) -> String

    var body: some View {
        ScreenContainer(backdrop: .coral) {
            SlideHeader()
            Text("Quem domina o grupo")
                .textStyle(.slideTitle)
                .accessibilityAddTraits(.isHeader)
                .entrance()
            SlidePhraseBubble()
            Spacer(minLength: 0)
            GroupPodium(podium: podium, displayName: displayName)
        }
        .slideFooter()
    }
}

#Preview {
    PodiumSlide(
        podium: [.init(name: "Bia", count: 4212), .init(name: "Rafa", count: 3108), .init(name: "Nicole", count: 2877)],
        displayName: { $0 == "Nicole" ? "Você" : $0 }
    )
    .slidePreview(phrase: .init(emoji: "👑", text: "Bia fala mais que o resto do grupo somado (ou quase)."))
}

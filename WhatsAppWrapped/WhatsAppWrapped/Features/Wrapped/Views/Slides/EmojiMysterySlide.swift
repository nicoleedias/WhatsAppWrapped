//
//  EmojiMysterySlide.swift
//  WhatsAppWrapped
//
//  10a–10b: suspense antes do emoji #1. "Calculando…" vira "Quase lá…" e o slide avança sozinho.
//

import SwiftUI

struct EmojiMysterySlide: StorySlide {
    static let label = "Emoji"
    static let isShareable = false

    let emojis: [String]
    @Environment(\.slideContext) private var context

    /// 10a → 10b → 11.
    static let stageDuration: Duration = .seconds(1.6)

    @State private var stage = EmojiMysteryScene.Stage.calculating

    var body: some View {
        ScreenContainer(backdrop: .plum) {
            EmojiMysteryScene(stage: stage, emojis: emojis)
        } content: {
            SlideHeader()
            Text(stage == .calculating ? "Calculando…" : "Quase lá…")
                .textStyle(.slideTitle)
                .frame(maxWidth: .infinity)
                .contentTransition(.opacity)
            Spacer(minLength: 0)
        }
        .slideFooter()
        .task {
            try? await Task.sleep(for: Self.stageDuration)
            withAnimation(.easeInOut(duration: Motion.base)) { stage = .almostThere }
            try? await Task.sleep(for: Self.stageDuration)
            guard !Task.isCancelled else { return }
            context.advance()
        }
    }
}

#Preview {
    EmojiMysterySlide(emojis: EmojiMysteryScene.defaultEmojis)
    .slidePreview()
}

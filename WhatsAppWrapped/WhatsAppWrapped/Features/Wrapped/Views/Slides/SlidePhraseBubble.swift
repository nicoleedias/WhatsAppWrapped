//
//  SlidePhraseBubble.swift
//  WhatsAppWrapped
//
//  O balão da frase da IA, lido do `SlideContext`. Só aparece quando o slide tem frase.
//

import SwiftUI

struct SlidePhraseBubble: View {
    @Environment(\.slideContext) private var context

    var body: some View {
        if let phrase = context.phrase {
            PhraseBubble(emoji: phrase.emoji, text: phrase.text)
        }
    }
}

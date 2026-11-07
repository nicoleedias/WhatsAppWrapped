//
//  AudioComparison.swift
//  WhatsAppWrapped
//
//  Slide 17: um balão de áudio por pessoa, com o nome em cima. Quem exportou (ou quem mais manda, no grupo)
//  fica com o balão de tinta; o outro, com o creme.
//

import SwiftUI

struct AudioComparison: View {
    struct Entry {
        let name: String
        /// "18h", "3h".
        let duration: String
    }

    let first: Entry
    let second: Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            LabeledAudioBubble(entry: first, side: .you)
                .entrance(delay: 0.4)
            LabeledAudioBubble(entry: second, side: .contact)
                .entrance(delay: 0.4 + Motion.cascadeStep)
        }
    }
}

private struct LabeledAudioBubble: View {
    let entry: AudioComparison.Entry
    let side: AudioBubble.Side

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(entry.name)
                .textStyle(.label)
                .accessibilityHidden(true)
            AudioBubble(duration: entry.duration, side: side)
                .accessibilityLabel("\(entry.name): \(entry.duration) de áudio")
        }
    }
}

#Preview {
    AudioComparison(first: .init(name: "Você", duration: "18h"), second: .init(name: "Nicole", duration: "3h"))
        .padding(32)
        .background(.rose)
}

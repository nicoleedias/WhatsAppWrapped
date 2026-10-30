//
//  AudioBubble.swift
//  WhatsAppWrapped
//
//  Bolha de áudio: play + mini waveform + duração. Você = tinta/lima; contato = creme/coral escuro.
//

import SwiftUI

struct AudioBubble: View {
    enum Side {
        case you, contact

        var background: Color { self == .you ? .ink : .cream }
        var foreground: Color { self == .you ? .cream : .ink }
        var playBackground: Color { self == .you ? .lime : .coralDeep }
        /// O ▶ é tinta nos dois lados, como no Figma.
        var playForeground: Color { .ink }
        var tail: BubbleShape.Tail { self == .you ? .bottomTrailing : .bottomLeading }

        /// Alturas das barras do waveform no Figma (cada lado tem o seu desenho).
        var waveform: [CGFloat] {
            switch self {
            case .you: [8, 22, 26, 16, 16, 26, 22, 8, 22, 25, 15, 16, 26, 22, 9, 22, 25, 15, 17, 26, 22, 9]
            case .contact: [23, 25, 14, 18, 26, 21, 10, 23, 25, 14, 18, 26, 20, 10, 23, 25, 13, 18, 26, 20, 11, 24]
            }
        }
    }

    let duration: String
    let side: Side

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "play.fill")
                .font(.system(size: 14))
                .foregroundStyle(side.playForeground)
                .frame(width: 40, height: 40)
                .background(side.playBackground, in: .circle)
            HStack(spacing: 3) {
                ForEach(side.waveform.indices, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .frame(width: 3, height: side.waveform[index])
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipped()
            Text(duration)
                .textStyle(.bodySBold)
        }
        .foregroundStyle(side.foreground)
        .padding(12)
        .frame(height: 64)
        .background(side.background, in: BubbleShape(radius: 28, tail: side.tail))
        .accessibilityElement()
        .accessibilityLabel("Áudio de \(duration)")
    }
}

#Preview {
    VStack {
        AudioBubble(duration: "18h", side: .you)
        AudioBubble(duration: "3h", side: .contact)
    }
    .padding(32)
    .background(.butter)
}

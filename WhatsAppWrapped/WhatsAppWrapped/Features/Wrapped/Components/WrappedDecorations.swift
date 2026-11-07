//
//  WrappedDecorations.swift
//  WhatsAppWrapped
//
//  Decorações dos slides, com as posições dos frames de 393×852 do Figma:
//  ondas (08, 13, 18), estrelas girando (09, 12, 15, 21), arcos atrás do emoji #1 (11)
//  e anéis nos cantos (14, 20). Horário (16) e ligação (17b) têm decoração própria.
//

import SwiftUI

// MARK: - Ondas

extension WavesDecoration {
    /// Traço de 44 pt (08 e 13).
    private static let boldSize = CGSize(width: 524, height: 134)

    /// 08 Total: manteiga, creme e ameixa na base.
    static let messages = WavesDecoration(waves: [
        Wave(image: .decoSquiggleBoldCream, center: CGPoint(x: 174, y: 709.84), slide: 32, rotation: 6, size: boldSize),
        Wave(image: .decoSquiggleBoldPlum, center: CGPoint(x: 194, y: 769.84), slide: 40, rotation: 6, size: boldSize),
        Wave(image: .decoSquiggleBoldButter, center: CGPoint(x: 164, y: 649.84), slide: 24, rotation: 6, size: boldSize),
    ])

    /// 13 Palavra #1: manteiga, ameixa e coral na base.
    static let words = WavesDecoration(waves: [
        Wave(image: .decoSquiggleBoldPlum, center: CGPoint(x: 174, y: 709.84), slide: 32, rotation: 6, size: boldSize),
        Wave(image: .decoSquiggleBoldCoral, center: CGPoint(x: 194, y: 769.84), slide: 40, rotation: 6, size: boldSize),
        Wave(image: .decoSquiggleBoldButter, center: CGPoint(x: 164, y: 649.84), slide: 24, rotation: 6, size: boldSize),
    ])

    /// 18 Textão: uma onda coral, mais fina (traço de 36 pt).
    static let longMessage = WavesDecoration(waves: [
        Wave(image: .decoSquiggleThinCoral, center: CGPoint(x: 174, y: 769.84), slide: 32, rotation: 6, size: CGSize(width: 516, height: 126)),
    ])
}

// MARK: - Estrelas

extension BurstDecoration {
    /// 09 Risadas: estrela coral grande atrás do 😂.
    static let laughs = BurstDecoration(
        image: .decoBurst,
        size: CGSize(width: 409.47, height: 420),
        center: CGPoint(x: 297.18, y: 568.73),
        startAngle: -8
    )

    /// 12 Quiz: estrela rosa no canto de cima.
    static let quiz = BurstDecoration(
        image: .decoBurstRose,
        size: CGSize(width: 233.98, height: 240),
        center: CGPoint(x: 372.33, y: 2.43),
        startAngle: -12
    )

    /// 15 Sequência: estrela manteiga atrás do 🔥.
    static let streak = BurstDecoration(
        image: .decoBurstButter,
        size: CGSize(width: 370.47, height: 380),
        center: CGPoint(x: 358.82, y: 699.1),
        startAngle: -6
    )

    /// 21 Resumo final: estrela lilás no canto de cima.
    static let summary = BurstDecoration(
        image: .decoBurstLilac,
        size: CGSize(width: 194.99, height: 200),
        center: CGPoint(x: 395.85, y: 11.12),
        startAngle: -10
    )
}

// MARK: - Arcos e anéis

extension ConcentricDecoration {
    /// 11 Emoji #1: coral, manteiga e creme crescendo do centro, atrás do emoji.
    static let emojiChampion = ConcentricDecoration(
        layers: [
            Layer(image: .decoArcCoral600, diameter: 440),
            Layer(image: .decoArcButter320, diameter: 340),
            Layer(image: .decoArcCream240, diameter: 240),
        ],
        center: CGPoint(x: 196.5, y: 380),
        animation: .growCascade
    )

    /// 14 Resposta: anéis coral e manteiga saindo do canto de baixo.
    static let responseTime = ConcentricDecoration(
        layers: [
            Layer(image: .decoRingBoldCoral320, diameter: 320),
            Layer(image: .decoRingBoldButter232, diameter: 232),
            Layer(image: .decoRingBoldCoral144, diameter: 144),
            Layer(image: .decoRingBoldButter56, diameter: 56),
        ],
        center: CGPoint(x: 440, y: 930)
    )

    /// 20 Quem nunca aparece: anéis lilás e ameixa no canto de cima.
    static let ghosts = ConcentricDecoration(
        layers: [
            Layer(image: .decoRingLilac320, diameter: 320),
            Layer(image: .decoRingPlum232, diameter: 232),
            Layer(image: .decoRingLilac144, diameter: 144),
            Layer(image: .decoRingPlum56, diameter: 56),
        ],
        center: CGPoint(x: 400, y: 0)
    )
}

// MARK: - Emoji grande

/// Emoji decorativo grande na base do slide (😂 em 09, 🔥 em 15), na frente da estrela.
struct DecorationEmoji: View {
    let emoji: String
    let size: CGFloat
    /// Centro no frame do Figma.
    let center: CGPoint

    var body: some View {
        FigmaCanvas { scale in
            Text(emoji)
                .font(.system(size: scale.length(size)))
                .position(scale.point(center))
        }
    }

    static func laughs(_ emoji: String = "😂") -> DecorationEmoji {
        DecorationEmoji(emoji: emoji, size: 120, center: CGPoint(x: 196, y: 582))
    }

    static func streak(_ emoji: String = "🔥") -> DecorationEmoji {
        DecorationEmoji(emoji: emoji, size: 140, center: CGPoint(x: 270, y: 725))
    }
}

#Preview("09 Risadas") {
    ZStack {
        Color.butter
        BurstDecoration.laughs
        DecorationEmoji.laughs()
    }
    .ignoresSafeArea()
}

#Preview("11 Emoji #1") {
    ZStack {
        Color.rose
        ConcentricDecoration.emojiChampion
    }
    .ignoresSafeArea()
}

#Preview("13 Palavras") {
    ZStack {
        Color.lime
        WavesDecoration.words
    }
    .ignoresSafeArea()
}

#Preview("20 Fantasmas") {
    ZStack {
        Color.ink
        ConcentricDecoration.ghosts
    }
    .ignoresSafeArea()
}

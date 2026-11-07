//
//  ImportDecorations.swift
//  WhatsAppWrapped
//
//  Decorações das telas 03 (ondas creme e ameixa), 04–06 (anéis no canto) e 07 (arcos manteiga, rosa, coral e ameixa).
//

import SwiftUI

extension WavesDecoration {
    static let chooseFile = WavesDecoration(waves: [
        Wave(image: .decoSquiggleCream, center: CGPoint(x: 151.4, y: 547.96), slide: 24),
        Wave(image: .decoSquigglePlum, center: CGPoint(x: 191.4, y: 617.96), slide: 32),
    ])
}

extension ConcentricDecoration {
    static let loading = ConcentricDecoration(
        layers: [
            Layer(image: .decoRingRose320, diameter: 320),
            Layer(image: .decoRingButter232, diameter: 232),
            Layer(image: .decoRingRose144, diameter: 144),
            Layer(image: .decoRingButter56, diameter: 56),
        ],
        center: CGPoint(x: 400, y: 20)
    )

    static let ready = bottomArcs([.decoArcButter600, .decoArcRose460, .decoArcCoral320, .decoArcPlum180])
}

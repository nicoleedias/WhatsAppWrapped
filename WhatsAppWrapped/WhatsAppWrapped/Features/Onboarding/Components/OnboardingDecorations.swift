//
//  OnboardingDecorations.swift
//  WhatsAppWrapped
//
//  Decorações das telas 01 (arcos coral, rosa, manteiga e lima) e 02 (estrela coral no canto).
//

import SwiftUI

extension ConcentricDecoration {
    static let onboarding = bottomArcs([.decoArcCoral600, .decoArcRose460, .decoArcButter320, .decoArcLime180])
}

extension BurstDecoration {
    static let exportGuide = BurstDecoration(
        size: CGSize(width: 214.484, height: 220),
        center: CGPoint(x: 377.43, y: 19.23)
    )
}

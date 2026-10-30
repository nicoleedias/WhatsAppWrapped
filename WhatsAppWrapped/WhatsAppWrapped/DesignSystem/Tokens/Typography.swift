//
//  Typography.swift
//  WhatsAppWrapped
//
//  Estilos de texto da identidade visual (Nunito em toda a interface). Use `.textStyle(.bodyL)` nas views.
//  Todos acompanham o tamanho de texto do sistema (Dynamic Type).
//

import SwiftUI

struct TextStyle {
    enum Weight: String {
        case regular = "Regular"
        case medium = "Medium"
        case semibold = "SemiBold"
        case bold = "Bold"
        case extraBold = "ExtraBold"
    }

    let size: CGFloat
    let weight: Weight
    /// Altura da linha no Figma. nil usa a altura natural da fonte.
    var lineHeight: CGFloat?
    var tracking: CGFloat = 0
    var relativeTo: Font.TextStyle = .body
    var uppercase = false

    var font: Font {
        .custom("Nunito-\(weight.rawValue)", size: size, relativeTo: relativeTo)
    }
}

// MARK: - Tokens (Identidade visual › 02 Tipografia)

extension TextStyle {
    /// 96/104 · Bold · -1%. Números gigantes dos slides.
    static let displayXL = TextStyle(size: 96, weight: .bold, lineHeight: 104, tracking: -0.96, relativeTo: .largeTitle)
    /// 64/72 · Bold. Números e títulos de destaque.
    static let displayL = TextStyle(size: 64, weight: .bold, lineHeight: 72, tracking: -0.64, relativeTo: .largeTitle)
    /// 44/52 · Bold · -1%. Títulos das telas.
    static let heading1 = TextStyle(size: 44, weight: .bold, lineHeight: 52, tracking: -0.44, relativeTo: .largeTitle)
    /// 32/40 · ExtraBold.
    static let heading2 = TextStyle(size: 32, weight: .extraBold, lineHeight: 40, relativeTo: .title)
    /// 24/32 · ExtraBold. Títulos de cards e emojis pequenos.
    static let title = TextStyle(size: 24, weight: .extraBold, lineHeight: 32, relativeTo: .title2)
    /// 18/26 · Medium.
    static let bodyL = TextStyle(size: 18, weight: .medium, lineHeight: 26, relativeTo: .body)
    /// 16/24 · Medium.
    static let bodyM = TextStyle(size: 16, weight: .medium, lineHeight: 24, relativeTo: .callout)
    /// 14/20 · Medium.
    static let bodyS = TextStyle(size: 14, weight: .medium, lineHeight: 20, relativeTo: .subheadline)
    /// 12/16 · Bold · +10% · caixa alta.
    static let label = TextStyle(size: 12, weight: .bold, lineHeight: 16, tracking: 1.2, relativeTo: .caption, uppercase: true)
    /// 11/16 · Medium.
    static let caption = TextStyle(size: 11, weight: .medium, lineHeight: 16, relativeTo: .caption2)

    // Variações usadas pelos componentes.

    /// 18/26 · SemiBold. Texto dos botões.
    static let button = TextStyle(size: 18, weight: .semibold, lineHeight: 26, relativeTo: .headline)
    /// 20 · SemiBold. Opções do quiz.
    static let option = TextStyle(size: 20, weight: .semibold, relativeTo: .headline)
    /// 16/24 · Bold. Título de alertas.
    static let headline = TextStyle(size: 16, weight: .bold, lineHeight: 24, relativeTo: .headline)
    /// 14/20 · Bold. Ações pequenas e durações.
    static let bodySBold = TextStyle(size: 14, weight: .bold, lineHeight: 20, relativeTo: .subheadline)
}

extension View {
    func textStyle(_ style: TextStyle) -> some View {
        font(style.font)
            .tracking(style.tracking)
            .lineHeight(style.lineHeight.map { .exact(points: $0) })
            .textCase(style.uppercase ? .uppercase : nil)
    }
}

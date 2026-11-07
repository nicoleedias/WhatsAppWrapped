//
//  BubbleShape.swift
//  WhatsAppWrapped
//
//  Formato de balão de conversa: cantos arredondados com a "pontinha" (raio 6) em um dos cantos de baixo.
//  Usado pelos balões de mensagem, áudio, frase da IA e digitando.
//

import SwiftUI

struct BubbleShape: Shape {
    enum Tail {
        /// Mensagem recebida (pontinha à esquerda).
        case bottomLeading
        /// Mensagem enviada (pontinha à direita).
        case bottomTrailing
    }

    let radius: CGFloat
    let tail: Tail
    var tailRadius: CGFloat = 6

    func path(in rect: CGRect) -> Path {
        UnevenRoundedRectangle(
            topLeadingRadius: radius,
            bottomLeadingRadius: tail == .bottomLeading ? tailRadius : radius,
            bottomTrailingRadius: tail == .bottomTrailing ? tailRadius : radius,
            topTrailingRadius: radius
        )
        .path(in: rect)
    }
}

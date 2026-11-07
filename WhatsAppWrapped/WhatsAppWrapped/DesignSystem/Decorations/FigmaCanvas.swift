//
//  FigmaCanvas.swift
//  WhatsAppWrapped
//
//  Camada para posicionar decorações com as coordenadas do frame de 393×852 do Figma.
//  Converte para o tamanho real da tela, mantendo a mesma distância proporcional das bordas.
//

import SwiftUI

struct FigmaScale {
    static let frame = CGSize(width: 393, height: 852)
    let size: CGSize

    /// Ponto do frame do Figma na tela atual.
    func point(_ point: CGPoint) -> CGPoint {
        CGPoint(x: point.x * size.width / Self.frame.width, y: point.y * size.height / Self.frame.height)
    }

    /// Tamanhos escalam pela largura, para as formas não ficarem achatadas.
    func length(_ length: CGFloat) -> CGFloat {
        length * size.width / Self.frame.width
    }
}

struct FigmaCanvas<Content: View>: View {
    @ViewBuilder let content: (FigmaScale) -> Content

    var body: some View {
        GeometryReader { geometry in
            content(FigmaScale(size: geometry.size))
        }
        .accessibilityHidden(true)
    }
}

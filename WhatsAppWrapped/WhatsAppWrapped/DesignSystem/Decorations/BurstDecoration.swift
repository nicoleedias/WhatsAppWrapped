//
//  BurstDecoration.swift
//  WhatsAppWrapped
//
//  Estrela que gira devagar (30° em 6 s, ida e volta), posicionada pelo centro no frame do Figma.
//

import SwiftUI

struct BurstDecoration: View {
    var image: ImageResource = .decoBurst
    /// Tamanho da estrela sem rotação, no Figma.
    let size: CGSize
    let center: CGPoint
    /// Ângulo inicial; gira até `startAngle + 30°`.
    var startAngle: Double = -10

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isRotated = false

    var body: some View {
        FigmaCanvas { scale in
            Image(image)
                .resizable()
                .frame(width: scale.length(size.width), height: scale.length(size.height))
                .rotationEffect(.degrees(startAngle + (isRotated ? 30 : 0)))
                .position(scale.point(center))
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 6).repeatForever()) { isRotated = true }
        }
    }
}

//
//  WavesDecoration.swift
//  WhatsAppWrapped
//
//  Ondas inclinadas que deslizam 24–40 pt para a direita em 2,4 s (ida e volta).
//

import SwiftUI

struct WavesDecoration: View {
    struct Wave {
        let image: ImageResource
        /// Centro no frame do Figma.
        let center: CGPoint
        /// Quanto a onda desliza.
        let slide: CGFloat
        var rotation: Double = 8
    }

    /// Tamanho da imagem da onda (480×90 mais a espessura do traço).
    static let size = CGSize(width: 520, height: 130)

    let waves: [Wave]

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var hasSlid = false

    var body: some View {
        FigmaCanvas { scale in
            ForEach(waves.indices, id: \.self) { index in
                let wave = waves[index]
                Image(wave.image)
                    .resizable()
                    .frame(width: scale.length(Self.size.width), height: scale.length(Self.size.height))
                    .rotationEffect(.degrees(wave.rotation))
                    .offset(x: hasSlid ? 0 : -wave.slide)
                    .position(scale.point(wave.center))
            }
        }
        .onAppear {
            guard !reduceMotion else { return }
            withAnimation(.easeInOut(duration: 2.4).repeatForever()) { hasSlid = true }
        }
    }
}

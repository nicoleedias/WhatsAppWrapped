//
//  RotatingCaption.swift
//  WhatsAppWrapped
//
//  Frase de baixo das telas 04–06, que troca a cada `interval` subindo com fade.
//

import SwiftUI

struct RotatingCaption: View {
    let captions: [String]
    var interval: Duration = .seconds(2)

    @State private var index = 0

    var body: some View {
        Text(captions[index])
            .textStyle(.bodyM)
            .id(index)
            .transition(.asymmetric(insertion: .offset(y: 16).combined(with: .opacity), removal: .opacity))
            .task {
                while !Task.isCancelled {
                    try? await Task.sleep(for: interval)
                    withAnimation(.easeOut(duration: Motion.base)) { index = (index + 1) % captions.count }
                }
            }
    }
}

#Preview {
    RotatingCaption(captions: ["Um", "Dois", "Três"])
}

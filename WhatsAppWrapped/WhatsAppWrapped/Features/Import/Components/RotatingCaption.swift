//
//  RotatingCaption.swift
//  WhatsAppWrapped
//
//  Frase de baixo das telas 04–06, que troca a cada `interval` subindo com fade.
//

import SwiftUI

struct RotatingCaption: View {
    var interval: Duration = .seconds(2)

    /// Embaralhadas uma vez, para cada carregamento começar e seguir numa ordem diferente.
    @State private var captions: [String]
    @State private var index = 0

    init(captions: [String], interval: Duration = .seconds(2)) {
        _captions = State(initialValue: captions.shuffled())
        self.interval = interval
    }

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

//
//  LoadingView.swift
//  WhatsAppWrapped
//
//  Telas 04–06: "Analisando mensagens" com o balão digitando e a frase de baixo trocando a cada 2 s,
//  enquanto a conversa é analisada e a IA escreve as frases.
//

import SwiftUI

struct LoadingView: View {
    static let captions = [
        "Contando quantos “kkkkk” você mandou.",
        "Medindo seus textões…",
        "Caçando seu emoji favorito…",
    ]

    var body: some View {
        ScreenContainer(backdrop: .coral) {
            ConcentricDecoration.loading
        } content: {
            Spacer(minLength: 0)
            Text("Analisando mensagens")
                .textStyle(.heading1)
                .entrance()
            TypingBubble()
            RotatingCaption(captions: Self.captions)
            Spacer(minLength: 0)
        }
    }
}

#Preview {
    LoadingView()
}

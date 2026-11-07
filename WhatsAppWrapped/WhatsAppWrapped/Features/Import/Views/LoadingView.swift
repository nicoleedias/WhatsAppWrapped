//
//  LoadingView.swift
//  WhatsAppWrapped
//
//  Telas 04–06: "Analisando mensagens" com o balão digitando e a frase de baixo trocando a cada 2 s,
//  em ordem aleatória, enquanto a conversa é analisada e a IA escreve as frases.
//

import SwiftUI

struct LoadingView: View {
    static let captions = [
        "Contando quantos “kkkkk” vocês mandaram…",
        "Medindo os textões…",
        "Caçando o emoji favorito de vocês…",
        "Descobrindo quem some sem avisar…",
        "Cronometrando quem demora pra responder…",
        "Somando os áudios de 5 minutos…",
        "Separando as figurinhas…",
        "Contando as ligações…",
        "Vendo quem conversa de madrugada…",
        "Folheando o rolo da câmera…",
        "Achando a palavra que vocês mais falam…",
        "Calculando a maior sequência de dias…",
        "Procurando o maior textão do ano…",
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

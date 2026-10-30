//
//  HeadlineStat.swift
//  WhatsAppWrapped
//
//  Abertura dos slides de número: frase curta + número gigante + legenda, entrando em sequência
//  ("Você possui / 30.597 / mensagens trocadas com Nicole"). Usado em 08, 09, 15, 16, 17 e 17d.
//  Fica dentro do VStack da tela, que cuida do espaçamento de 24 entre as linhas.
//

import SwiftUI

struct HeadlineStat: View {
    var intro: String?
    let value: String
    let caption: String
    var introStyle: TextStyle = .slideIntro
    var valueStyle: TextStyle = .displayXL
    var captionStyle: TextStyle = .bodyL
    /// nil usa a cor do texto do fundo.
    var valueColor: Color?
    @Environment(\.backdrop) private var backdrop

    var body: some View {
        if let intro {
            Text(intro)
                .textStyle(introStyle)
                .entrance()
        }
        Text(value)
            .textStyle(valueStyle, minimumScale: 0.5)
            .foregroundStyle(valueColor ?? backdrop.foreground)
            .entrance(delay: 0.15, offset: 32, duration: Motion.slow)
            .accessibilityAddTraits(.isHeader)
        Text(caption)
            .textStyle(captionStyle)
            .entrance(delay: 0.3)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 24) {
        HeadlineStat(intro: "Você possui", value: "30.597", caption: "mensagens trocadas com Nicole")
    }
    .padding(32)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(.coral)
}

#Preview("15 Sequência") {
    VStack(alignment: .leading, spacing: 24) {
        HeadlineStat(value: "95", caption: "dias seguidos trocando mensagem", valueStyle: .numberGiant, captionStyle: .slideSubtitle, valueColor: .butter)
    }
    .padding(32)
    .frame(maxWidth: .infinity, alignment: .leading)
    .foregroundStyle(.cream)
    .background(.plum)
    .environment(\.backdrop, .plum)
}

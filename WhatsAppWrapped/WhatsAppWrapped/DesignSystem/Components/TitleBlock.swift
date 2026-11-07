//
//  TitleBlock.swift
//  WhatsAppWrapped
//
//  Rótulo em caixa alta + título grande, entrando em sequência. Abre as telas de onboarding e importação.
//  Fica dentro do VStack da tela, que cuida do espaçamento de 24 entre os dois.
//

import SwiftUI

struct TitleBlock: View {
    let label: String
    let title: String
    var titleStyle: TextStyle = .heading1

    var body: some View {
        Text(label)
            .textStyle(.label)
            .entrance()
        Text(title)
            .textStyle(titleStyle)
            .minimumScaleFactor(0.7)
            .entrance(delay: 0.1)
            .accessibilityAddTraits(.isHeader)
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 24) {
        TitleBlock(label: "Como exportar", title: "Como exportar sua conversa")
    }
    .padding(32)
}

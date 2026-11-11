//
//  TitleBlock.swift
//  WhatsAppWrapped
//
//  Rótulo em caixa alta + título grande, entrando em sequência. Abre as telas de onboarding e importação.
//  Fica dentro do VStack da tela, que cuida do espaçamento de 24 entre os dois.
//  Com `back`, aparece uma seta de voltar antes do rótulo (o gesto da borda esquerda continua valendo).
//

import SwiftUI

struct TitleBlock: View {
    let label: String
    let title: String
    var titleStyle: TextStyle = .heading1
    var back: (() -> Void)?

    var body: some View {
        HStack(spacing: 8) {
            if let back {
                Button(action: back) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        // Área de toque de 44 pt sem empurrar o rótulo para a direita.
                        .frame(width: 44, height: 44)
                        .contentShape(.rect)
                        .padding(-12)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Voltar")
            }
            Text(label)
                .textStyle(.label)
        }
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
        TitleBlock(label: "Como exportar", title: "Como exportar sua conversa", back: {})
    }
    .padding(32)
}

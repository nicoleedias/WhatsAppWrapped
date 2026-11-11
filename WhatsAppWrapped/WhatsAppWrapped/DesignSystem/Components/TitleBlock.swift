//
//  TitleBlock.swift
//  WhatsAppWrapped
//
//  Rótulo em caixa alta + título grande, entrando em sequência. Abre as telas de onboarding e importação.
//  Fica dentro do VStack da tela, que cuida do espaçamento de 24 entre os dois.
//  Com `back`, um botão de voltar aparece no lugar do rótulo (o gesto da borda esquerda continua valendo).
//

import SwiftUI

struct TitleBlock: View {
    let label: String
    let title: String
    var titleStyle: TextStyle = .heading1
    var back: (() -> Void)?

    var body: some View {
        // Com botão de voltar, o rótulo sai: ele repetia o título e deixava a seta espremida.
        Group {
            if let back {
                BackButton(action: back)
            } else {
                Text(label).textStyle(.label)
            }
        }
        .entrance()
        Text(title)
            .textStyle(titleStyle)
            .minimumScaleFactor(0.7)
            .entrance(delay: 0.1)
            .accessibilityAddTraits(.isHeader)
    }
}

/// Seta de voltar em círculo de contorno, no estilo do "Compartilhar" das histórias.
struct BackButton: View {
    let action: () -> Void
    @Environment(\.backdrop) private var backdrop

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 16, weight: .semibold))
                .frame(width: 44, height: 44)
                .overlay { Circle().strokeBorder(backdrop.foreground, lineWidth: 1.5) }
                .contentShape(.circle)
        }
        .buttonStyle(.plain)
        .foregroundStyle(backdrop.foreground)
        .accessibilityLabel("Voltar")
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 24) {
        TitleBlock(label: "Como exportar", title: "Como exportar sua conversa", back: {})
    }
    .padding(32)
}

//
//  PrivacyNotice.swift
//  WhatsAppWrapped
//
//  Cadeado + uma frase curta. Aparece onde a pessoa decide enviar ou guardar algo: envio do arquivo,
//  lista de retrospectivas e estado vazio.
//

import SwiftUI

struct PrivacyNotice: View {
    var text = "Só guardamos os números da sua retrospectiva. Suas mensagens não ficam salvas."

    var body: some View {
        HStack(spacing: 12) {
            Text("🔒")
                .textStyle(.bodyL)
                .accessibilityHidden(true)
            Text(text)
                .textStyle(.bodyS)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .foregroundStyle(.ink)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.ink.opacity(0.06), in: .rect(cornerRadius: 20))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    PrivacyNotice()
        .padding(32)
        .background(.cream)
}

//
//  DeleteConfirmation.swift
//  WhatsAppWrapped
//
//  00d: diálogo centrado sobre o véu escuro. Título com o nome da conversa, uma frase que tira o medo,
//  "Apagar" em cima e "Cancelar" embaixo.
//

import SwiftUI

struct DeleteConfirmation: View {
    /// "Apagar a retrospectiva com Nicole?".
    let title: String
    let confirm: () -> Void
    let cancel: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("🗑️")
                .textStyle(.title)
                .frame(width: 56, height: 56)
                .background(.coralDeep, in: .circle)
                .accessibilityHidden(true)
            Text(title)
                .textStyle(.title)
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)
            Text("Isso não apaga sua conversa no WhatsApp. Você pode rebobinar de novo quando quiser.")
                .textStyle(.bodyM)
                .multilineTextAlignment(.center)
                .opacity(0.85)
            VStack(spacing: 16) {
                Button("Apagar", role: .destructive, action: confirm)
                    .buttonStyle(.rebobina(.destructive))
                Button("Cancelar", role: .cancel, action: cancel)
                    .buttonStyle(.rebobina(.secondary))
            }
        }
        .foregroundStyle(.ink)
        .padding(24)
        .background(.cream, in: .rect(cornerRadius: 32))
        .shadow(color: Color.night.opacity(0.25), radius: 10, y: 16)
        // "Cancelar" usa o contorno na cor do texto do fundo: aqui, tinta sobre creme.
        .environment(\.backdrop, .cream)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
    }
}

#Preview {
    ZStack {
        Color.ink.opacity(0.45).ignoresSafeArea()
        DeleteConfirmation(title: "Apagar a retrospectiva com Nicole?", confirm: {}, cancel: {})
            .padding(32)
    }
}

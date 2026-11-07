//
//  FileDropzone.swift
//  WhatsAppWrapped
//
//  Área tracejada da tela 03 para escolher o .zip ou .txt. Mostra o nome do arquivo escolhido
//  e fica em coral escuro quando o arquivo é inválido (03b).
//

import SwiftUI

struct FileDropzone: View {
    let fileName: String?
    let hasError: Bool
    let action: () -> Void

    private var tint: Color { hasError ? .coralDeep : .ink }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text("📎")
                    .font(.system(size: 40))
                    .accessibilityHidden(true)
                Text(fileName ?? "Coloque o .zip ou .txt aqui")
                    .textStyle(.button)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }
            .foregroundStyle(.ink)
            .padding(.vertical, 40)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(hasError ? Color.coralDeep.opacity(0.1) : .clear, in: .rect(cornerRadius: 32))
            .overlay {
                RoundedRectangle(cornerRadius: 32)
                    .strokeBorder(tint, style: StrokeStyle(lineWidth: 2, dash: [8, 6]))
            }
            .contentShape(.rect(cornerRadius: 32))
        }
        .buttonStyle(.plain)
        .animation(.easeOut(duration: Motion.fast), value: hasError)
        .accessibilityHint("Abre o app Arquivos")
    }
}

#Preview {
    VStack(spacing: 24) {
        FileDropzone(fileName: nil, hasError: false) {}
        FileDropzone(fileName: "WhatsApp Chat - Nicole.zip", hasError: false) {}
        FileDropzone(fileName: nil, hasError: true) {}
    }
    .padding(32)
    .background(.lilac)
}

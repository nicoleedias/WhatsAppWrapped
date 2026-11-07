//
//  ExportGuideView.swift
//  WhatsAppWrapped
//
//  Tela 02: os 4 passos para exportar a conversa no WhatsApp e compartilhar direto com o app,
//  ou a opção de salvar em Arquivos e escolher na tela 03.
//

import SwiftUI

struct ExportGuideView: View {
    let openWhatsApp: () -> Void
    let showFilePicker: () -> Void

    var body: some View {
        ScreenContainer(backdrop: .cream) {
            BurstDecoration.exportGuide
        } content: {
            TitleBlock(label: "Como exportar", title: "Como exportar sua conversa")
            ExportStepList(steps: ExportStep.all)
            Spacer(minLength: 0)
            VStack(spacing: 16) {
                Button("Abrir o WhatsApp", action: openWhatsApp)
                    .buttonStyle(.rebobina(.primary))
                Button("Prefiro salvar em arquivos", action: showFilePicker)
                    .buttonStyle(.rebobina(.secondary))
            }
        }
    }
}

#Preview {
    ExportGuideView(openWhatsApp: {}, showFilePicker: {})
}

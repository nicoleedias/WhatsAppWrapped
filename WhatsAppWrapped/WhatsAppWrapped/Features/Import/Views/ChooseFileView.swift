//
//  ChooseFileView.swift
//  WhatsAppWrapped
//
//  Telas 03 e 03b: escolher o .zip ou .txt no app Arquivos. Quando o arquivo não serve,
//  o alerta desce do topo e o card do arquivo fica vermelho e balança.
//

import SwiftUI
import UniformTypeIdentifiers

struct ChooseFileView: View {
    let viewModel: ImportViewModel
    @State private var isPickingFile = false
    @State private var failureCount = 0

    var body: some View {
        ScreenContainer(backdrop: .lilac) {
            WavesDecoration.chooseFile
        } content: {
            TitleBlock(label: "Outra forma", title: "Escolha “Salvar em arquivos”")
            FileDropzone(
                fileName: viewModel.selectedFile?.lastPathComponent,
                hasError: viewModel.failure != nil
            ) {
                isPickingFile = true
            }
            .shake(trigger: failureCount)
            .entrance(delay: 0.2)
            Spacer(minLength: 0)
            Button("Analisar conversa", action: viewModel.analyzeSelectedFile)
                .buttonStyle(.rebobina(.primary))
                .disabled(viewModel.selectedFile == nil)
        }
        .topAlert(isPresented: viewModel.failure != nil) {
            AlertBanner(
                kind: .error,
                title: viewModel.failure?.title ?? "",
                message: viewModel.failure?.message ?? "",
                actionTitle: "Tentar de novo",
                action: viewModel.dismissFailure
            )
        }
        .onChange(of: viewModel.failure) { _, failure in
            if failure != nil { failureCount += 1 }
        }
        .fileImporter(isPresented: $isPickingFile, allowedContentTypes: [.zip, .plainText]) { result in
            if case .success(let url) = result { viewModel.selectFile(url) }
        }
    }
}

#Preview {
    ChooseFileView(viewModel: ImportViewModel(phraseGenerator: PreviewPhraseGenerator()))
}

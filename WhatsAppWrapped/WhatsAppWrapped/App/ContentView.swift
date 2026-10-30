//
//  ContentView.swift
//  WhatsAppWrapped
//
//  Created by Nicole Dias on 07/10/26.
//
//  Tela raiz: mostra a parte do app em que a pessoa está, com fade entre as telas,
//  e recebe o arquivo compartilhado do WhatsApp. Arrastar da borda esquerda volta uma tela.
//

import SwiftUI

struct ContentView: View {
    let viewModel: AppViewModel
    @Environment(\.openURL) private var openURL

    var body: some View {
        ZStack {
            switch viewModel.step {
            case .onboarding:
                OnboardingView(start: viewModel.start)
            case .exportGuide:
                ExportGuideView(
                    openWhatsApp: { openURL(AppViewModel.whatsAppURL) },
                    showFilePicker: viewModel.showFilePicker
                )
            case .importing:
                ImportFlowView(viewModel: viewModel.importer, showWrapped: viewModel.showWrapped)
            case .wrapped:
                if let result = viewModel.importer.result {
                    WrappedView(result: result, startOver: viewModel.startOver)
                }
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: Motion.base), value: viewModel.step)
        .gesture(backSwipe)
        // Fundo escuro no onboarding: status bar clara.
        .preferredColorScheme(viewModel.step == .onboarding ? .dark : .light)
        // Arquivo vindo do WhatsApp pelo compartilhamento ("Escolha Rebobina na lista").
        .onOpenURL(perform: viewModel.importFile)
    }

    /// As telas do Figma não têm botão de voltar; o gesto da borda esquerda faz esse papel.
    private var backSwipe: some Gesture {
        DragGesture(minimumDistance: 20)
            .onEnded { drag in
                if drag.startLocation.x < 32 && drag.translation.width > 80 { viewModel.goBack() }
            }
    }
}

#Preview {
    ContentView(viewModel: AppViewModel(phraseGenerator: GeminiPhraseGenerator()))
}

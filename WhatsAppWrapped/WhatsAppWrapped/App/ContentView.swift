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
    let coordinator: AppCoordinator
    @Environment(\.openURL) private var openURL

    var body: some View {
        ZStack {
            switch coordinator.step {
            case .retrospectives:
                RetrospectivesView(
                    viewModel: coordinator.retrospectives,
                    openSummary: coordinator.openSummary,
                    replay: coordinator.replay,
                    newRetrospective: coordinator.newRetrospective
                )
            case .onboarding:
                OnboardingView(start: coordinator.start)
            case .exportGuide:
                ExportGuideView(
                    openWhatsApp: { openURL(AppCoordinator.whatsAppURL) },
                    showFilePicker: coordinator.showFilePicker,
                    goBack: coordinator.goBack
                )
            case .importing:
                ImportFlowView(viewModel: coordinator.importer, showWrapped: coordinator.showWrapped, goBack: coordinator.goBack)
            case .wrapped:
                if let wrapped = coordinator.wrapped {
                    WrappedView(viewModel: wrapped)
                }
            case .summary:
                if let result = coordinator.current {
                    SummaryView(
                        viewModel: SummaryViewModel(result: result),
                        segmentCount: WrappedViewModel.makeSlides(for: result.stats).count + 1,
                        showRetrospectives: coordinator.showRetrospectives
                    )
                }
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: Motion.base), value: coordinator.step)
        .gesture(backSwipe)
        // Fundo escuro no onboarding: status bar clara.
        .preferredColorScheme(coordinator.step == .onboarding ? .dark : .light)
        // Arquivo vindo do WhatsApp pelo compartilhamento ("Escolha Rebobina na lista").
        .onOpenURL(perform: coordinator.importFile)
    }

    /// As telas do Figma não têm botão de voltar; o gesto da borda esquerda faz esse papel.
    private var backSwipe: some Gesture {
        DragGesture(minimumDistance: 20)
            .onEnded { drag in
                if drag.startLocation.x < 32 && drag.translation.width > 80 { coordinator.goBack() }
            }
    }
}

#Preview {
    ContentView(coordinator: AppCoordinator(phraseGenerator: PreviewPhraseGenerator(), store: PreviewRetrospectiveStore()))
}

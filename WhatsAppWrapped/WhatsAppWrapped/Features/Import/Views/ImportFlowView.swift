//
//  ImportFlowView.swift
//  WhatsAppWrapped
//
//  Mostra a tela da importação em que a pessoa está (escolher arquivo, permissão da IA, carregando, compra ou pronto), com fade entre elas.
//

import SwiftUI

struct ImportFlowView: View {
    let viewModel: ImportViewModel
    let showWrapped: () -> Void
    let goBack: () -> Void

    var body: some View {
        ZStack {
            switch viewModel.phase {
            // A permissão da IA é um sheet sobre a tela de envio; fechar o sheet cancela, sem enviar nada.
            case .chooseFile, .consent:
                ChooseFileView(viewModel: viewModel, goBack: goBack)
                    .sheet(isPresented: isAskingConsent) {
                        AIConsentSheet(
                            primary: .init(title: "Permitir e continuar", perform: viewModel.allowAI),
                            secondary: .init(title: "Continuar sem IA", perform: viewModel.continueWithoutAI)
                        )
                    }
            case .loading:
                LoadingView()
            case .paywall:
                PaywallView(viewModel: viewModel, goBack: goBack)
            case .ready:
                ReadyView(year: viewModel.retrospectiveYear, isTrial: viewModel.isTrialResult, showWrapped: showWrapped)
            }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: Motion.base), value: viewModel.phase)
    }

    private var isAskingConsent: Binding<Bool> {
        Binding(
            get: { viewModel.phase == .consent },
            set: { if !$0 { viewModel.cancelConsent() } }
        )
    }
}

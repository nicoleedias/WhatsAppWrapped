//
//  ImportFlowView.swift
//  WhatsAppWrapped
//
//  Mostra a tela da importação em que a pessoa está (escolher arquivo, carregando, compra ou pronto), com fade entre elas.
//

import SwiftUI

struct ImportFlowView: View {
    let viewModel: ImportViewModel
    let showWrapped: () -> Void
    let goBack: () -> Void

    var body: some View {
        ZStack {
            switch viewModel.phase {
            case .chooseFile:
                ChooseFileView(viewModel: viewModel, goBack: goBack)
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
}

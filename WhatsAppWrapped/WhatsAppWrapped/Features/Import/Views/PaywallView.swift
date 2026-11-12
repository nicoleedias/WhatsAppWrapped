//
//  PaywallView.swift
//  WhatsAppWrapped
//
//  Compra da retrospectiva completa: os últimos 12 meses da conversa, por um preço único.
//  Aparece quando a retrospectiva grátis já foi usada, ou no "Ver o ano inteiro" do resumo da grátis.
//  O preço vem da App Store (Rebobina.storekit no simulador), já formatado na moeda da pessoa.
//

import SwiftUI

struct PaywallView: View {
    let viewModel: ImportViewModel
    let goBack: () -> Void

    private var buttonTitle: String {
        viewModel.price.map { "Desbloquear por \($0)" } ?? "Desbloquear"
    }

    var body: some View {
        ScreenContainer(backdrop: .cream) {
            ConcentricDecoration.ready
        } content: {
            TitleBlock(label: "Retrospectiva completa", title: "Rebobine o ano inteiro", back: goBack)
            Text("Os últimos 12 meses desta conversa, com todos os slides e frases feitas sob medida para vocês.")
                .textStyle(.bodyL)
                .entrance(delay: 0.2)
            VStack(alignment: .leading, spacing: 4) {
                if let price = viewModel.price {
                    Text(price)
                        .textStyle(.heading2)
                } else if viewModel.isLoadingPrice {
                    ProgressView()
                        .frame(height: 40)
                }
                Text("Pagamento único, sem assinatura.")
                    .textStyle(.bodyS)
            }
            .entrance(delay: 0.3)
            if let message = viewModel.purchaseMessage {
                Text(message)
                    .textStyle(.bodyS)
                    .transition(.opacity)
            }
            Spacer(minLength: 0)
            Button(action: viewModel.buy) {
                if viewModel.isPurchasing {
                    ProgressView().tint(.cream)
                } else {
                    Text(buttonTitle)
                }
            }
            .buttonStyle(.rebobina(.primary))
            // Sem preço o botão continua ativo: a compra busca o produto de novo.
            .disabled(viewModel.isPurchasing || viewModel.isLoadingPrice)
        }
        .animation(.easeInOut(duration: Motion.base), value: viewModel.purchaseMessage)
        .animation(.easeInOut(duration: Motion.base), value: viewModel.price)
    }
}

#Preview {
    PaywallView(
        viewModel: ImportViewModel(
            phraseGenerator: PreviewPhraseGenerator(),
            purchases: PreviewPurchases(),
            freeTrial: PreviewFreeTrial()
        ),
        goBack: {}
    )
}

//
//  OnboardingView.swift
//  WhatsAppWrapped
//
//  Tela 01: apresentação do app sobre ameixa, com os arcos subindo da base, e botão "Começar".
//

import SwiftUI

struct OnboardingView: View {
    let start: () -> Void
    /// "Já exportei minha conversa": pula o passo a passo e vai direto para o envio do arquivo.
    let alreadyExported: () -> Void

    private var year: String {
        Calendar.current.component(.year, from: .now).formatted(.number.grouping(.never))
    }

    var body: some View {
        ScreenContainer(backdrop: .plum, bottomPadding: 80) {
            ConcentricDecoration.onboarding
        } content: {
            TitleBlock(label: "Rebobina · \(year)", title: "Suas conversas têm história.", titleStyle: .displayL)
            Text("Quem manda textão, quem some, quem nunca manda um emoji decente. A gente descobre.")
                .textStyle(.bodyL)
                .entrance(delay: 0.2)
            Spacer(minLength: 0)
            VStack(spacing: 8) {
                Button("Começar", action: start)
                    .buttonStyle(.rebobina(.primaryOnDark))
                Button("Já exportei minha conversa", action: alreadyExported)
                    .buttonStyle(.rebobina(.ghost))
            }
        } footer: {
            SourceNote(text: "Usa a conversa que você exporta do WhatsApp.\nNão afiliado ao WhatsApp.")
                .padding(.bottom, 12)
        }
    }
}

#Preview {
    OnboardingView(start: {}, alreadyExported: {})
}

//
//  AIConsentSheet.swift
//  WhatsAppWrapped
//
//  Explicação do uso da IA em bottom sheet (diretriz 5.1.2(i)): o que vai, para quem e o que acontece com o
//  resumo. Aparece antes da primeira retrospectiva (sobre a tela de envio) e ao tocar em "Frases com IA" no
//  rodapé de "Minhas retrospectivas". Os botões mudam conforme o lugar; o sheet se ajusta à altura do conteúdo.
//

import SwiftUI

struct AIConsentSheet: View {
    struct Action {
        let title: String
        let perform: () -> Void
    }

    let primary: Action
    let secondary: Action

    @State private var height: CGFloat = 420

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("✨")
                .font(.system(size: 40))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 8) {
                Text("Frases feitas com IA")
                    .textStyle(.title)
                    .accessibilityAddTraits(.isHeader)
                Text("Para escrever as frases dos slides, o Rebobina manda ao **Gemini**, a IA do **Google**, só os nomes de quem participa e as estatísticas da conversa.")
                    .textStyle(.bodyM)
                    .fixedSize(horizontal: false, vertical: true)
            }
            PrivacyNotice(text: "Suas mensagens nunca saem do celular. O resumo não fica guardado e não treina a IA.")
            VStack(spacing: 4) {
                Button(primary.title, action: primary.perform)
                    .buttonStyle(.rebobina(.primary))
                Button(secondary.title, action: secondary.perform)
                    .buttonStyle(.rebobina(.ghost))
            }
        }
        .foregroundStyle(.ink)
        .padding(.horizontal, 24)
        .padding(.top, 32)
        .padding(.bottom, 8)
        .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { height = $0 }
        .presentationDetents([.height(height)])
        .presentationDragIndicator(.visible)
        .presentationBackground(.cream)
        .presentationCornerRadius(32)
    }
}

#Preview {
    Color.lilac
        .ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            AIConsentSheet(
                primary: .init(title: "Permitir e continuar") {},
                secondary: .init(title: "Continuar sem IA") {}
            )
        }
}

//
//  RetrospectivesFooter.swift
//  WhatsAppWrapped
//
//  Rodapé discreto de "Minhas retrospectivas": o atalho "Frases com IA · ligadas/desligadas", que abre a
//  explicação com o botão de ligar ou desligar, e a frase do cadeado. Fica depois dos cartões, para as
//  retrospectivas virem primeiro.
//

import SwiftUI

struct RetrospectivesFooter: View {
    let consent: AIConsent
    @State private var isShowingAI = false

    var body: some View {
        VStack(spacing: 12) {
            Button { isShowingAI = true } label: {
                HStack(spacing: 6) {
                    Text("✨ Frases com IA")
                    Text(consent.isAllowed ? "ligadas" : "desligadas")
                        .textStyle(.bodySBold)
                        .contentTransition(.opacity)
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .accessibilityHidden(true)
                }
                .textStyle(.bodyS)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.ink.opacity(0.06), in: .capsule)
                .contentShape(.capsule)
            }
            .buttonStyle(.plain)
            .accessibilityHint("Mostra o que é enviado e deixa ligar ou desligar")
            Text("🔒 Só guardamos os números da retrospectiva. Suas mensagens não ficam salvas.")
                .textStyle(.caption)
                .opacity(0.7)
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(.ink)
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: Motion.fast), value: consent.isAllowed)
        .sheet(isPresented: $isShowingAI) {
            if consent.isAllowed {
                AIConsentSheet(
                    primary: .init(title: "Manter ligadas") { isShowingAI = false },
                    secondary: .init(title: "Desligar frases com IA") { decide(.declined) }
                )
            } else {
                AIConsentSheet(
                    primary: .init(title: "Ativar frases com IA") { decide(.allowed) },
                    secondary: .init(title: "Agora não") { isShowingAI = false }
                )
            }
        }
    }

    private func decide(_ decision: AIConsent.Decision) {
        consent.decide(decision)
        isShowingAI = false
    }
}

#Preview {
    VStack(spacing: 40) {
        RetrospectivesFooter(consent: AIConsent(defaults: nil))
        RetrospectivesFooter(consent: { let on = AIConsent(defaults: nil); on.decide(.allowed); return on }())
    }
    .padding(32)
    .frame(maxHeight: .infinity)
    .background(.cream)
}

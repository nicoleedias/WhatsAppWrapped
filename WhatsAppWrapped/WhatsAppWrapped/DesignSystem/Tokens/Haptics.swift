//
//  Haptics.swift
//  WhatsAppWrapped
//
//  Vibrações que acompanham as animações: o número que sobe, a figurinha colando, o emoji campeão, o
//  telefone tocando. Sempre leves e no mesmo tempo da animação, para a vibração parecer o "peso" dela.
//  A imagem de compartilhar não vibra: o `ImageRenderer` não roda `task`.
//

import SwiftUI

extension View {
    /// Toca `feedback` uma vez, `delay` segundos depois de a view aparecer (junto com a entrada dela).
    func hapticOnAppear(_ feedback: SensoryFeedback, delay: Double = 0) -> some View {
        modifier(AppearHaptic(feedback: feedback, delay: delay))
    }
}

private struct AppearHaptic: ViewModifier {
    let feedback: SensoryFeedback
    let delay: Double

    @State private var hasFired = false

    func body(content: Content) -> some View {
        content
            .sensoryFeedback(feedback, trigger: hasFired) { _, fired in fired }
            .task {
                try? await Task.sleep(for: .seconds(delay))
                guard !Task.isCancelled else { return }
                hasFired = true
            }
    }
}

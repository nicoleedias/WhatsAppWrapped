//
//  IncomingCallSlide.swift
//  WhatsAppWrapped
//
//  17b: quem mais ligou "chamando" na tela. Atender ou recusar leva para os números das ligações (17c).
//

import SwiftUI

struct IncomingCallSlide: StorySlide {
    static let label = "Ligações"
    static let isShareable = false

    let call: WrappedSlide.IncomingCall
    @Environment(\.slideContext) private var context
    /// Cada vibração do "trim-trim". Muda a cada 0,15 s nos toques e para no resto do ciclo.
    @State private var buzzes = 0

    var body: some View {
        ScreenContainer(backdrop: .plum) {
            SlideHeader()
            Spacer(minLength: 0)
            IncomingCallCaller(name: call.name, status: "chamando…", isGroup: call.isGroup)
            Spacer(minLength: 0)
            IncomingCallActions(decline: context.advance, accept: context.advance)
        }
        .slideFooter()
        .sensoryFeedback(.impact(weight: .heavy, intensity: 0.8), trigger: buzzes)
        .task { await ring() }
    }

    /// Vibra como um celular tocando, no mesmo ciclo dos anéis, até a pessoa atender ou recusar.
    private func ring() async {
        let gap = 0.15
        while !Task.isCancelled {
            buzzes += 1
            try? await Task.sleep(for: .seconds(gap))
            buzzes += 1
            try? await Task.sleep(for: .seconds(IncomingCallRings.loopDuration - gap))
        }
    }
}

#Preview {
    IncomingCallSlide(call: .init(name: "Bia", isGroup: false))
    .slidePreview()
}

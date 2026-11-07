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

    var body: some View {
        ScreenContainer(backdrop: .plum) {
            SlideHeader()
            Spacer(minLength: 0)
            IncomingCallCaller(name: call.name, status: "chamando…", isGroup: call.isGroup)
            Spacer(minLength: 0)
            IncomingCallActions(decline: context.advance, accept: context.advance)
        }
        .slideFooter()
    }
}

#Preview {
    IncomingCallSlide(call: .init(name: "Bia", isGroup: false))
    .slidePreview()
}

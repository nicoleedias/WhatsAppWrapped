//
//  EmptyRetrospectives.swift
//  WhatsAppWrapped
//
//  00b: o balão lilás "digitando" e o convite para rebobinar a primeira conversa.
//

import SwiftUI

struct EmptyRetrospectives: View {
    var body: some View {
        VStack(spacing: 16) {
            TypingBubble(style: .lilac)
                .popEntrance(delay: 0.1)
            Text("Nenhuma conversa rebobinada ainda")
                .textStyle(.title)
                .accessibilityAddTraits(.isHeader)
                .entrance(delay: 0.2)
            Text("Exporte uma conversa do WhatsApp e a gente transforma um ano em histórias.")
                .textStyle(.bodyM)
                .opacity(0.85)
                .entrance(delay: 0.3)
        }
        .multilineTextAlignment(.center)
        .foregroundStyle(.ink)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    EmptyRetrospectives()
        .padding(32)
        .background(.cream)
}

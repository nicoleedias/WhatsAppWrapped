//
//  MessageBubble.swift
//  WhatsAppWrapped
//
//  Balão de mensagem: recebido à esquerda (creme) ou enviado à direita (tinta, com ✓✓ em lima).
//

import SwiftUI

struct MessageBubble: View {
    enum Side {
        case received, sent
    }

    let text: String
    let side: Side

    var body: some View {
        HStack(spacing: 8) {
            Text(text)
                .textStyle(.bodyM)
            if side == .sent {
                Text("✓✓")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.lime)
                    .accessibilityLabel("Lida")
            }
        }
        .foregroundStyle(side == .sent ? Color.cream : .ink)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            side == .sent ? Color.ink : .cream,
            in: BubbleShape(radius: 24, tail: side == .sent ? .bottomTrailing : .bottomLeading)
        )
        .frame(maxWidth: .infinity, alignment: side == .sent ? .trailing : .leading)
    }
}

#Preview {
    VStack {
        MessageBubble(text: "vc tá aí?", side: .received)
        MessageBubble(text: "vc tá aí?", side: .sent)
    }
    .padding()
    .background(.lilac)
}

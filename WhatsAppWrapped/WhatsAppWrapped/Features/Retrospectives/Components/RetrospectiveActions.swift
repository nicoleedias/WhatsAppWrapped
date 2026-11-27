//
//  RetrospectiveActions.swift
//  WhatsAppWrapped
//
//  00c: bottom sheet aberto pelo ••• do cartão. Rever histórias, compartilhar a imagem do resumo e apagar,
//  sempre por último e em vermelho. O resumo abre com um toque no próprio cartão.
//

import SwiftUI

struct RetrospectiveActions: View {
    /// Imagem do resumo; enquanto não fica pronta, "Compartilhar" aparece desativado.
    let shareImage: Image?
    let replay: () -> Void
    let delete: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ActionRow(emoji: "🔁", title: "Rever histórias", action: replay)
            Group {
                if let shareImage {
                    ShareLink(item: shareImage, preview: SharePreview("Minha retrospectiva do WhatsApp", image: shareImage)) {
                        ActionLabel(emoji: "📤", title: "Compartilhar")
                    }
                    .buttonStyle(.plain)
                } else {
                    ActionLabel(emoji: "📤", title: "Compartilhar")
                        .opacity(0.4)
                }
            }
            .overlay(alignment: .top) { divider }
            ActionRow(emoji: "🗑️", title: "Apagar retrospectiva", titleColor: .coralDeep, action: delete)
                .overlay(alignment: .top) { divider }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .foregroundStyle(.ink)
    }

    /// Três linhas de 58 pt, o respiro de cima e a área da barra de início.
    static let height: CGFloat = 253

    private var divider: some View {
        Rectangle()
            .fill(Color.ink.opacity(0.1))
            .frame(height: 1)
    }
}

private struct ActionRow: View {
    let emoji: String
    let title: String
    var titleColor: Color = .ink
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ActionLabel(emoji: emoji, title: title, titleColor: titleColor)
        }
        .buttonStyle(.plain)
    }
}

private struct ActionLabel: View {
    let emoji: String
    let title: String
    var titleColor: Color = .ink

    var body: some View {
        HStack(spacing: 16) {
            Text(emoji)
                .textStyle(.bodyL)
                .accessibilityHidden(true)
            Text(title)
                .textStyle(TextStyle(size: 18, weight: .bold, lineHeight: 26, relativeTo: .body))
                .foregroundStyle(titleColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 16)
        .contentShape(.rect)
    }
}

#Preview {
    Color.plum.opacity(0.5)
        .sheet(isPresented: .constant(true)) {
            RetrospectiveActions(shareImage: nil, replay: {}, delete: {})
                .presentationDetents([.height(RetrospectiveActions.height)])
                .presentationBackground(.cream)
                .presentationCornerRadius(32)
        }
}

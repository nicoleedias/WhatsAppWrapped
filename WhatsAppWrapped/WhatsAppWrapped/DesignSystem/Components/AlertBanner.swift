//
//  AlertBanner.swift
//  WhatsAppWrapped
//
//  Alerta que desce do topo, sem tela própria: ícone + título + mensagem + ação.
//  Erro = coral escuro (arquivo inválido); Aviso = manteiga (conversa curta demais, arquivo grande).
//

import SwiftUI

struct AlertBanner: View {
    enum Kind {
        case error, warning

        var background: Color { self == .error ? .coralDeep : .butter }
        var foreground: Color { self == .error ? .cream : .ink }
        /// Fundo do ícone e da ação; o texto deles usa `background`.
        var accent: Color { self == .error ? .cream : .ink }
    }

    let kind: Kind
    let title: String
    let message: String
    let actionTitle: String
    let action: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("!")
                .textStyle(TextStyle(size: 18, weight: .extraBold, lineHeight: 26))
                .foregroundStyle(kind.background)
                .frame(width: 32, height: 32)
                .background(kind.accent, in: .circle)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(title).textStyle(.headline)
                Text(message).textStyle(.bodyS)
                Button(actionTitle, action: action)
                    .textStyle(.bodySBold)
                    .foregroundStyle(kind.background)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(kind.accent, in: .capsule)
                    .padding(.top, 4)
            }
            .foregroundStyle(kind.foreground)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(kind.background, in: .rect(cornerRadius: 24))
        .shadow(color: .ink.opacity(0.25), radius: 6, y: 8)
        .accessibilityElement(children: .contain)
    }
}

extension View {
    /// Mostra o alerta descendo do topo (com pop) enquanto `isPresented` for verdadeiro.
    func topAlert(isPresented: Bool, topInset: CGFloat = 56, @ViewBuilder alert: () -> AlertBanner) -> some View {
        overlay(alignment: .top) {
            if isPresented {
                alert()
                    .padding(.horizontal, 32)
                    .padding(.top, topInset)
                    .transition(.offset(y: -160).combined(with: .opacity))
            }
        }
        .animation(Motion.pop, value: isPresented)
    }
}

#Preview {
    VStack(spacing: 24) {
        AlertBanner(
            kind: .error,
            title: "Esse arquivo não é uma conversa do WhatsApp",
            message: "Exporte de novo pelo WhatsApp e envie o .zip ou .txt.",
            actionTitle: "Tentar de novo"
        ) {}
        AlertBanner(
            kind: .warning,
            title: "Essa conversa é bem curtinha",
            message: "Com menos de 100 mensagens, alguns dados podem ficar vazios.",
            actionTitle: "Continuar assim"
        ) {}
    }
    .padding(32)
    .background(.lilac)
}

//
//  ReadyView.swift
//  WhatsAppWrapped
//
//  Tela 07: "Prontinho!" sobre lima, com o ✓ dando um pop, e o botão para ver os slides.
//

import SwiftUI

struct ReadyView: View {
    let year: Int?
    let showWrapped: () -> Void

    private var message: String {
        guard let year else { return "Sua retrospectiva está pronta." }
        return "Sua retrospectiva \(year.formatted(.number.grouping(.never))) está pronta."
    }

    var body: some View {
        ScreenContainer(backdrop: .lime) {
            ConcentricDecoration.ready
        } content: {
            Spacer(minLength: 0)
            ReadyCheckmark()
            Text("Prontinho!")
                .textStyle(.displayL)
                .entrance(delay: 0.15)
            Text(message)
                .textStyle(.bodyL)
                .entrance(delay: 0.25)
            Spacer(minLength: 0)
            Button("Ver minha retrospectiva", action: showWrapped)
                .buttonStyle(.rebobina(.primary))
        }
    }
}

#Preview {
    ReadyView(year: 2026, showWrapped: {})
}

//
//  WrappedView.swift
//  WhatsAppWrapped
//
//  Slides da retrospectiva. Por enquanto é uma lista provisória com os números e as frases, até os slides existirem.
//

import SwiftUI

struct WrappedView: View {
    let result: WrappedResult
    let startOver: () -> Void

    var body: some View {
        NavigationStack {
            List {
                Section("Números") {
                    LabeledContent("Mensagens", value: "\(result.stats.messages.total)")
                    LabeledContent("Risadas", value: "\(result.stats.laughs.total)")
                    LabeledContent("Ligações", value: "\(result.stats.calls.total)")
                    LabeledContent("Sequência", value: "\(result.stats.streak.longest) dias")
                }
                Section("Frases") {
                    ForEach(PhraseSlide.allCases, id: \.self) { slide in
                        if let phrase = result.phrases[slide] {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(slide.rawValue).font(.caption).foregroundStyle(.secondary)
                                Text("\(phrase.emoji) \(phrase.text)")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Resultado")
            .toolbar { Button("Outra conversa", action: startOver) }
        }
    }
}

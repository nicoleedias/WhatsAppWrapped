//
//  CallsSlide.swift
//  WhatsAppWrapped
//
//  17c: total de ligações, voz × vídeo e a duração média, sobre lilás.
//

import SwiftUI

struct CallsSlide: StorySlide {
    static let label = "Ligações"
    static let phraseSlide: PhraseSlide? = .calls

    let calls: WrappedSlide.Calls

    var body: some View {
        ScreenContainer(backdrop: .lilac) {
            SlideHeader()
            // Menor que os outros títulos, porque divide a tela com três cards; o `fixedSize` não deixa cortar.
            Text(calls.title)
                .textStyle(.heading2)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)
                .entrance()
            HStack(alignment: .top, spacing: 12) {
                CallTypeCard(kind: .voice, count: calls.voice, percentage: calls.voicePercentage)
                CallTypeCard(kind: .video, count: calls.video, percentage: calls.videoPercentage)
            }
            if let average = calls.average {
                CallDurationCard(average: average, detail: calls.averageDetail)
            }
            SlidePhraseBubble()
            Spacer(minLength: 0)
        }
        .slideFooter()
    }
}

#Preview {
    CallsSlide(
        calls: .init(
            title: "Vocês se ligaram 128 vezes",
            voice: 96, video: 32, voicePercentage: 75, videoPercentage: 25,
            average: "14:07", averageDetail: "minutos por chamada · a maior durou 3h12"
        )
    )
    .slidePreview(phrase: .init(emoji: "🍜", text: "Dá pra fazer 4 miojos em cada ligação."))
}

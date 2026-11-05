//
//  HoursSlide.swift
//  WhatsAppWrapped
//
//  16a–16c: horário de pico. Fundo, cor do número e decoração mudam com o período do dia
//  (madrugada e noite com lua, manhã com sol, tarde com pôr do sol).
//

import SwiftUI

struct HoursSlide: StorySlide {
    static let label = "Horário"
    static let phraseSlide: PhraseSlide? = .hours

    let hours: WrappedSlide.Hours

    private var style: HourStyle { HourStyle(hours.partOfDay) }

    var body: some View {
        ScreenContainer(backdrop: style.backdrop) {
            HourDecoration(partOfDay: hours.partOfDay)
        } content: {
            SlideHeader()
            HeadlineStat(
                intro: hours.headline.intro,
                value: hours.headline.value,
                caption: hours.headline.caption,
                introStyle: .slideIntroLarge,
                valueColor: style.valueColor
            )
            SlidePhraseBubble()
            Spacer(minLength: 0)
        }
        .slideFooter()
    }
}

#Preview {
    HoursSlide(
        hours: .init(
            partOfDay: .lateNight,
            headline: .init(intro: "Vocês são do time da madrugada", value: "23h", caption: "é quando a conversa mais ferve")
        )
    )
    .slidePreview(phrase: .init(emoji: "😴", text: "Quem dorme cedo definitivamente não é você."))
}

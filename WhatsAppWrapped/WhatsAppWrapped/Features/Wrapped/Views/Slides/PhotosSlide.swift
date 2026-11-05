//
//  PhotosSlide.swift
//  WhatsAppWrapped
//
//  17d: fotos trocadas, as polaroids dos meses com mais fotos e o dia recorde, sobre coral.
//

import SwiftUI

struct PhotosSlide: StorySlide {
    static let label = "Fotos"
    static let phraseSlide: PhraseSlide? = .photos

    let photos: WrappedSlide.Photos

    var body: some View {
        ScreenContainer(backdrop: .coral) {
            SlideHeader()
            HeadlineStat(
                intro: photos.headline.intro,
                value: photos.headline.value,
                caption: photos.headline.caption,
                introStyle: .title,
                valueStyle: .numberPhotos
            )
            if !photos.polaroids.isEmpty {
                PolaroidStack(items: photos.polaroids)
            }
            if let busiestDay = photos.busiestDay {
                InfoChip(emoji: "📅", text: busiestDay)
            }
            SlidePhraseBubble()
            Spacer(minLength: 0)
        }
        .slideFooter()
    }
}

#Preview {
    PhotosSlide(
        photos: .init(
            headline: .init(intro: "Vocês trocaram", value: "2.273", caption: "fotos em 2026"),
            polaroids: [.init(emoji: "🌅", label: "jan"), .init(emoji: "🎉", label: "jul"), .init(emoji: "📸", label: "dez")],
            busiestDay: "25 de dezembro: 64 fotos num dia só"
        )
    )
    .slidePreview(phrase: .init(emoji: "📸", text: "Seu rolo da câmera pede férias."))
}

//
//  StoryPoster.swift
//  WhatsAppWrapped
//
//  Imagem de compartilhar no tamanho exato do story do Instagram: 1080×1920 px (9:16).
//
//  A tela é montada num quadro fixo de 480×853 pt (9:16), igual em qualquer iPhone, e desenhada a 2,25×.
//  O `ScreenContainer` usa margens próprias nesse quadro: o conteúdo ocupa a largura toda, o topo fica
//  abaixo da barra de perfil do Instagram e a base reserva espaço para o rodapé com o nome da conversa e
//  a nota de fonte (`StoryFooter`), acima do campo de resposta. A marca do app (`BrandMark`) vai no topo
//  dos slides, no lugar do botão de compartilhar, e no rodapé do resumo.
//

import SwiftUI
import UIKit

enum StoryPoster {
    /// Tamanho do story em pixels.
    static let pixelSize = CGSize(width: 1080, height: 1920)
    /// Quadro em pontos onde a tela é montada. 2,25× dá exatamente 1080×1920.
    static let canvas = CGSize(width: 480, height: 1920 / 2.25)

    /// Margens do conteúdo no quadro do story (no lugar das 32/64/48 da tela).
    static let horizontalPadding: CGFloat = 40
    /// Abaixo da foto e do nome de perfil que o Instagram desenha no topo.
    static let topPadding: CGFloat = 76
    /// Espaço do `StoryFooter` (só o chip, sem a marca) mais o respiro até o conteúdo.
    static let bottomPadding: CGFloat = 104
    /// Espaço entre blocos (24 na tela): o 9:16 é mais baixo que a tela do iPhone e os slides mais cheios
    /// (fotos, ligações) precisam desses pontos para o balão da IA caber em duas linhas.
    static let blockSpacing: CGFloat = 20
    /// Distância do `StoryFooter` até a base, acima do campo de resposta do Instagram.
    static let footerInset: CGFloat = 44

    /// Desenha `content` como story 1080×1920, sem as animações de entrada (o `ImageRenderer` não roda
    /// `onAppear`, então tudo precisa já aparecer no lugar) e com o tamanho de texto padrão.
    @MainActor
    static func render<Content: View>(@ViewBuilder _ content: () -> Content) -> UIImage? {
        let poster = content()
            .frame(width: canvas.width, height: canvas.height)
            .environment(\.isStoryPoster, true)
            .environment(\.showsEntrances, false)
            .dynamicTypeSize(.large)
        let renderer = ImageRenderer(content: poster)
        renderer.scale = pixelSize.width / canvas.width
        return renderer.uiImage
    }
}

extension EnvironmentValues {
    /// true ao montar a imagem do story. O `ScreenContainer` troca as margens pelas do quadro 9:16.
    @Entry var isStoryPoster = false
}

/// Rodapé da imagem compartilhada: nome da conversa e nota de fonte, num chip legível sobre as
/// decorações. No resumo, que não tem cabeçalho, a marca do app vem embaixo.
struct StoryFooter: View {
    /// "Você & Gabriel". nil no resumo, que já mostra os nomes no card.
    var chatName: String?
    var showsBrand = false

    var body: some View {
        VStack(spacing: 10) {
            SourceNote(text: [chatName, SourceNote.exportNote].compactMap { $0 }.joined(separator: "\n"))
            if showsBrand { BrandMark() }
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, StoryPoster.footerInset)
    }
}

/// Ícone do app + "rebobina", como na capa da identidade visual.
struct BrandMark: View {
    /// Altura do ícone. 24 no cabeçalho dos slides, 28 no rodapé do resumo.
    var iconSize: CGFloat = 28
    @Environment(\.backdrop) private var backdrop

    var body: some View {
        HStack(spacing: 8) {
            Image(.brandIcon)
                .resizable()
                .frame(width: iconSize, height: iconSize)
                .clipShape(.rect(cornerRadius: iconSize / 4, style: .continuous))
            Text("rebobina")
                .textStyle(TextStyle(size: iconSize * 0.78, weight: .extraBold, tracking: -iconSize * 0.0078, relativeTo: .title3))
        }
        .foregroundStyle(backdrop.foreground)
        .padding(.leading, 6)
        .padding(.trailing, 12)
        .padding(.vertical, 6)
        .background(backdrop.color, in: .capsule)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Feito com o app Rebobina")
    }
}

#Preview {
    VStack(spacing: 32) {
        StoryFooter(chatName: "Você & Gabriel")
            .padding().background(.coral).environment(\.backdrop, .coral)
        StoryFooter(showsBrand: true)
            .padding().background(.plum).environment(\.backdrop, .plum)
    }
}

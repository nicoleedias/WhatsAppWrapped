//
//  AvatarView.swift
//  WhatsAppWrapped
//
//  "Foto" do design system: círculo com a inicial da pessoa, com contorno de 3 pt na cor do fundo
//  para dar para sobrepor dois avatares. O tamanho de ligação (128) não tem contorno.
//

import SwiftUI

struct AvatarView: View {
    enum Size: CGFloat {
        case small = 40
        /// Pilha de participantes no resumo do grupo.
        case medium = 44
        case large = 64
        /// Quem está "ligando" no slide de ligações.
        case call = 128

        var textStyle: TextStyle {
            switch self {
            case .small, .large: .title
            case .medium: TextStyle(size: 16, weight: .extraBold, relativeTo: .headline)
            case .call: TextStyle(size: 44, weight: .extraBold, lineHeight: 52, tracking: -0.44, relativeTo: .largeTitle)
            }
        }

        var hasBorder: Bool { self != .call }
    }

    let name: String
    var size: Size = .small
    var fill: Color = .rose
    /// Grupos usam duas iniciais ("Rolê de sexta" → "RS").
    var maxInitials = 1
    @Environment(\.backdrop) private var backdrop

    var body: some View {
        Text(Self.initials(of: name, max: maxInitials))
            .textStyle(size.textStyle, minimumScale: 0.5)
            .foregroundStyle(.ink)
            .frame(width: size.rawValue, height: size.rawValue)
            .background(fill, in: .circle)
            .overlay {
                if size.hasBorder { Circle().strokeBorder(backdrop.color, lineWidth: 3) }
            }
            .accessibilityLabel(name)
    }

    /// Primeira letra das palavras que começam com maiúscula (ignora "de", "da"…). Sem letras, "?".
    static func initials(of name: String, max: Int) -> String {
        let words = name.split(separator: " ")
        let capitalized = words.filter { $0.first?.isUppercase == true }
        let letters = (capitalized.isEmpty ? words : capitalized)
            .compactMap { word in word.first { $0.isLetter } }
            .prefix(max)
        return letters.isEmpty ? "?" : String(letters).uppercased()
    }
}

#Preview {
    VStack(spacing: 24) {
        HStack(spacing: -12) {
            AvatarView(name: "Nicole")
            AvatarView(name: "Rafa", size: .large, fill: .butter)
            AvatarView(name: "Bia", size: .medium, fill: .lilac)
        }
        AvatarView(name: "Rolê de sexta", size: .call, maxInitials: 2)
    }
    .padding()
    .background(.plum)
    .environment(\.backdrop, .plum)
}

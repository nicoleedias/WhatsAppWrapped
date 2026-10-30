//
//  AvatarView.swift
//  WhatsAppWrapped
//
//  "Foto" do design system: círculo com a inicial da pessoa, com contorno de 3 pt na cor do fundo
//  para dar para sobrepor dois avatares.
//

import SwiftUI

struct AvatarView: View {
    enum Size: CGFloat {
        case small = 40
        case large = 64
    }

    let name: String
    var size: Size = .small
    var fill: Color = .rose
    @Environment(\.backdrop) private var backdrop

    var body: some View {
        Text(initial)
            .textStyle(.title)
            .foregroundStyle(.ink)
            .frame(width: size.rawValue, height: size.rawValue)
            .background(fill, in: .circle)
            .overlay { Circle().strokeBorder(backdrop.color, lineWidth: 3) }
            .accessibilityLabel(name)
    }

    private var initial: String {
        name.first { $0.isLetter }.map { String($0).uppercased() } ?? "?"
    }
}

#Preview {
    HStack(spacing: -12) {
        AvatarView(name: "Nicole")
        AvatarView(name: "Rafa", size: .large, fill: .butter)
    }
    .padding()
    .background(.plum)
    .environment(\.backdrop, .plum)
}

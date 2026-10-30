//
//  Backdrop.swift
//  WhatsAppWrapped
//
//  Fundos chapados das telas e o tom de cada um (claro ou escuro). O `ScreenContainer` coloca o fundo
//  no environment, e os componentes escolhem sozinhos as cores certas (tinta em fundo claro, creme em fundo escuro).
//

import SwiftUI

enum Backdrop: CaseIterable {
    case ink, cream, plum, night, coral, rose, butter, lilac, lime

    var color: Color {
        switch self {
        case .ink: .ink
        case .cream: .cream
        case .plum: .plum
        case .night: .night
        case .coral: .coral
        case .rose: .rose
        case .butter: .butter
        case .lilac: .lilac
        case .lime: .lime
        }
    }

    /// Ameixa, noite e tinta pedem texto creme.
    var isDark: Bool {
        [.ink, .plum, .night].contains(self)
    }

    /// Cor do texto e dos contornos sobre este fundo.
    var foreground: Color {
        isDark ? .cream : .ink
    }
}

extension EnvironmentValues {
    /// Fundo da tela atual. Definido pelo `ScreenContainer`.
    @Entry var backdrop: Backdrop = .cream
}

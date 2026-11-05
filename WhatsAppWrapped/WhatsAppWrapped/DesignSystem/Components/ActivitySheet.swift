//
//  ActivitySheet.swift
//  WhatsAppWrapped
//
//  Folha de compartilhar do iOS para quando a imagem só existe depois do toque (o `ShareLink` precisa
//  dela antes). Use com `.sheet(item:)`.
//

import SwiftUI
import UIKit

struct ActivitySheet: UIViewControllerRepresentable {
    /// Envolve a imagem para usar em `.sheet(item:)`.
    struct Item: Identifiable {
        let id = UUID()
        let image: UIImage
    }

    let item: Item

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [item.image], applicationActivities: nil)
    }

    func updateUIViewController(_ controller: UIActivityViewController, context: Context) {}
}

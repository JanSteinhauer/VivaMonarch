//
//  HubGrid.swift
//  VivaMonarch
//
//  Created by Steinhauer, Jan on 27.09.25.
//

import SwiftUI

struct HubGrid: View {
    let onOpenAmerica: () -> Void
    let onOpenGallery: () -> Void
    let onOpenBeginning: () -> Void
    let onOpenMonarchHome: () -> Void
    let onOpenCredits: () -> Void
//    let onOpenBonus: () -> Void
    let onOpenAIMonarch: () -> Void

    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            HubCard(image: "AmericaMap", title: "Journey America", action: onOpenAmerica)
            HubCard(image: "AnimalMigration", title: "Animal Migration", action: onOpenBeginning)
            HubCard(image: "GalleryIcon", title: "Gallery", action: onOpenGallery)

            HubCard(image: "MonarchMigration", title: "Monarch Home", action: onOpenMonarchHome)
            HubCard(image: "Credits", title: "Credits", action: onOpenCredits)
//            HubCard(image: "Bonus", title: "Bonus", action: onOpenBonus)
            HubCard(image: "MonarchAI", title: "AI Monarch", action: onOpenAIMonarch)
        }
        .background(Color.clear)
    }
}

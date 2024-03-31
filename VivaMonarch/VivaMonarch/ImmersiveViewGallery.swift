//
//  ImmersiveViewGallery.swift
//  VivaMonarch
//
//  Created by Jan Steinhauer on 3/31/24.
//
import SwiftUI
import RealityKit

struct ImmersiveViewGallery: View {

    @State var model = Gallery()

    var body: some View {
        RealityView { content in
            content.add(model.setupContentEntity())
        }
        .onTapGesture {
            model.toggleSorted()
        }
    }
}

#Preview {
    ImmersiveViewGallery()
        .previewLayout(.sizeThatFits)
}

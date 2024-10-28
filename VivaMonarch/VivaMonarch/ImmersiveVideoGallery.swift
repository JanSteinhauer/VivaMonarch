//
//  ImmersiveViewGallery.swift
//  VivaMonarch
//
//  Created by Jan Steinhauer on 3/31/24.
//
import SwiftUI
import RealityKit

struct ImmersiveVideoGallery: View {

    @State var model = VideoGallery()

    var body: some View {
        RealityView { content in
            content.add(model.setupContentEntity())
        }
       
    }
}

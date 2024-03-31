//
//  VivaMonarchApp.swift
//  VivaMonarch
//
//  Created by Jan Steinhauer on 3/31/24.
//

import SwiftUI

@main
struct VivaMonarchApp: App {
    @State private var viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView(viewModel: viewModel)
        }.immersionStyle(selection: .constant(.full), in: .full)
        ImmersiveSpace(id: "showImmersiveSpaceGallery") {
            ImmersiveViewGallery()
        }
    }
}

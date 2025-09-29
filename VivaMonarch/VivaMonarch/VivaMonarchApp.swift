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
    @State private var model = Title()
    

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .environment(model)
        }
       
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView(viewModel: viewModel)
        }.immersionStyle(selection: .constant(.full), in: .full)
        
        ImmersiveSpace(id: "showImmersiveSpaceGallery") {
            ImmersiveViewGallery()
        }
        
        ImmersiveSpace(id: "showImmersiveSpaceVideoGallery") {
            ImmersiveVideoGallery()
        }
        .immersionStyle(selection: .constant(.full), in: .full)
        
        ImmersiveSpace(id: "showImmersiveSpaceAmerica") {
            ViewModelMap()
        }
        .immersionStyle(selection: .constant(.full), in: .full)
        
        ImmersiveSpace(id: "showVieModelBeginning") {
            VieModelBeginning()
        }
        
        ImmersiveSpace(id: "CommonImmersiveSpace") {
            ImmersiveView(viewModel: viewModel)
        }
    }
}

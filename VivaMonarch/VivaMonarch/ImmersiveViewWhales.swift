//
//  ImmersiveViewWhales.swift
//  VivaMonarch
//
//  Created by Steinhauer, Jan on 11/9/24.
//

import SwiftUI
import RealityKit

struct ImmersiveViewWhales: View {
    var viewModel: ViewModelWhales

    @State private var effectEnabled = true
    @State private var strength: Float = 0

    var body: some View {
        ZStack {
            RealityView { content in
                content.add(viewModel.setupContentEntity())
            }
            .onAppear() {
                viewModel.play()
            }
            .onDisappear() {
                viewModel.pause()
            }
        }
    }
}




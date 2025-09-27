//
//  ViewModelBeginning.swift
//  VivaMonarch
//
//  Created by Steinhauer, Jan on 10/14/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import AVFAudio

struct VieModelBeginning: View {
    
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        ZStack {
            RealityView { content in
                
                if let entity = try? await Entity(named: "Immersive", in: realityKitContentBundle){
                    content.add(entity)
                    
                }
            }
        }
    }
}

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

    private func playSound(named soundFileName: String) {
        guard let path = Bundle.main.path(forResource: soundFileName, ofType: nil) else { return }
        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Could not load file")
        }
    }
    
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

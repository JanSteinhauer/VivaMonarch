//
//  AudioManager.swift
//  VivaMonarch
//
//  Created by Steinhauer, Jan on 27.09.25.
//

import SwiftUI
import AVFoundation

final class AudioManager: ObservableObject {
    @Published var audioPlayer: AVAudioPlayer?
    
    func playSound(named soundFileName: String) {
        guard let path = Bundle.main.path(forResource: soundFileName, ofType: nil) else {
            return
        }
        let url = URL(fileURLWithPath: path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Could not load file \(soundFileName): \(error)")
        }
    }
    
    func fadeOutAndStop(duration: TimeInterval = 0.4) {
        audioPlayer?.setVolume(0, fadeDuration: duration)
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in self?.stopAudio() }
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}

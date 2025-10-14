//
//  TTSManager.swift
//  VivaMonarch
//
//  Created by Steinhauer, Jan on 14.10.25.
//

import Foundation
import AVFoundation
import Combine

@MainActor
final class TTSManager: ObservableObject {
    private let synth = AVSpeechSynthesizer()

    func speak(_ text: String) {
        if synth.isSpeaking { synth.stopSpeaking(at: .immediate) }
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.48
        utterance.pitchMultiplier = 1.1
        utterance.prefersAssistiveTechnologySettings = true
        // Prefer device language; fallback to en-US
        if AVSpeechSynthesisVoice(language: Locale.current.identifier) != nil {
            utterance.voice = AVSpeechSynthesisVoice(language: Locale.current.identifier)
        } else {
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }
        synth.speak(utterance)
    }
}

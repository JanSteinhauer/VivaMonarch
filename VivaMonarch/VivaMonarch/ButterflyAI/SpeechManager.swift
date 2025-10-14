//
//  SpeechManager.swift
//  VivaMonarch
//
//  Created by Steinhauer, Jan on 14.10.25.
//

import Foundation
import AVFoundation
import Speech
import Combine

@MainActor
final class SpeechManager: ObservableObject {
    @Published private(set) var isRecording = false
    @Published private(set) var transcript: String = ""

    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let recognizer = SFSpeechRecognizer()

    init() {
        SFSpeechRecognizer.requestAuthorization { status in
            Task { @MainActor in
                // handle status if you track it (optional):
                // self.authorizationStatus = status
                // You can also prewarm AVAudioSession here if desired.
            }
        }
    }

    func toggle() { isRecording ? stop() : start() }

    func start() {
        guard !isRecording else { return }
        transcript = ""
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.record, mode: .measurement, options: [.duckOthers])
            try session.setActive(true)

            request = SFSpeechAudioBufferRecognitionRequest()
            request?.shouldReportPartialResults = true

            let inputNode = audioEngine.inputNode
            let format = inputNode.inputFormat(forBus: 0)
            inputNode.removeTap(onBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 2048, format: format) { [weak self] buffer, when in
                self?.request?.append(buffer)
            }

            audioEngine.prepare()
            try audioEngine.start()

            task = recognizer?.recognitionTask(with: request!, resultHandler: { [weak self] result, error in
                guard let self else { return }
                if let text = result?.bestTranscription.formattedString { self.transcript = text }
                if let error, (result?.isFinal ?? false) || error != nil { self.stop() }
            })

            isRecording = true
        } catch {
            stop()
        }
    }

    func stop() {
        isRecording = false
        task?.cancel(); task = nil
        request?.endAudio(); request = nil
        audioEngine.inputNode.removeTap(onBus: 0)
        audioEngine.stop()
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}

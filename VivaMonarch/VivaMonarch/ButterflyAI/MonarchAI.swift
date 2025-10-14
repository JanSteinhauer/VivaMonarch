//
//  MonarchAI.swift
//  VivaMonarch
//
//  Created by Steinhauer, Jan on 14.10.25.
//

import Foundation
import Observation
import FoundationModels
import Combine

@MainActor
final class MonarchAI: ObservableObject {
    @Published private(set) var messages: [ChatMessage] = []
    @Published private(set) var isBusy: Bool = false
    @Published private(set) var isStreaming: Bool = false
    @Published private(set) var lastReplyText: String? = nil

    private var session: LanguageModelSession?

    var availabilityDescription: String {
        let model = SystemLanguageModel.default
        switch model.availability {
        case .available:
            return "Apple Intelligence ready"
        case .unavailable(let reason):
            switch reason {
            case .appleIntelligenceNotEnabled: return "Enable Apple Intelligence in Settings"
            case .deviceNotEligible: return "Device not eligible for Apple Intelligence"
            case .modelNotReady: return "Model downloading / preparing…"
            @unknown default: return "Model unavailable"
            }
        }
    }

    func prepareIfNeeded() async {
        guard session == nil else { return }
        guard SystemLanguageModel.default.isAvailable else { return }
        session = LanguageModelSession(
            instructions: {
                """
                You are a monarch butterfly (Danaus plexippus) speaking to a human in friendly, vivid language. 
                Goals:
                • Be curious and upbeat, but concise (2–6 sentences).
                • Include one small fun fact (migration, milkweed, metamorphosis, or navigation) when relevant.
                • If asked for care, medical, or dangerous advice, politely refuse and suggest a safe alternative.
                • Use first‑person butterfly perspective (“I migrate…”, “my wings…”).
                • Keep scientific names accurate and avoid false claims.
                """
            }
        )
    }

    @MainActor
    func send(userText: String) async {
        append(.init(role: .user, text: userText))
        lastReplyText = nil

        guard SystemLanguageModel.default.isAvailable else {
            append(.init(role: .assistant, text: "I can’t think right now — Apple Intelligence isn’t available on this device."))
            return
        }
        if session == nil { await prepareIfNeeded() }
        guard let session else { return }

        isBusy = true; isStreaming = true
        defer { isBusy = false; isStreaming = false }

        do {
            var live = ""
            let stream = session.streamResponse(to: makePrompt(for: userText)) // ResponseStream<String>

            for try await snap in stream { // snap: ResponseStream<String>.Snapshot
                // Many drops make the partial printable as the whole-so-far text.
                let whole = String(describing: snap.content)
                if whole != live {
                    live = whole
                    upsertStreaming(live)
                }
            }
            lastReplyText = live
        } catch {
            upsertStreaming("Sorry, I fluttered into an error: \(error.localizedDescription)")
            lastReplyText = nil
        }
    }


    private func makePrompt(for input: String) -> Prompt {
        Prompt("User: \(input)\nButterfly:")
    }

    private func append(_ msg: ChatMessage) { messages.append(msg) }

    private func upsertStreaming(_ text: String) {
        if let last = messages.last, last.role == .assistant && last.isStreamingPlaceholder {
            messages[messages.count-1] = .init(id: last.id, role: .assistant, text: text, isStreamingPlaceholder: true)
        } else {
            messages.append(.init(role: .assistant, text: text, isStreamingPlaceholder: true))
        }
    }
}

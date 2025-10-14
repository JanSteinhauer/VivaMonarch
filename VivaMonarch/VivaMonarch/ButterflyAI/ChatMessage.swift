//
//  ChatMessage.swift
//  VivaMonarch
//
//  Created by Steinhauer, Jan on 14.10.25.
//

import Foundation

enum ChatRole { case user, assistant }

struct ChatMessage: Identifiable, Equatable {
    var id: UUID = .init()
    var role: ChatRole
    var text: String
    var timestamp: Date = .now
    var isStreamingPlaceholder: Bool = false
}


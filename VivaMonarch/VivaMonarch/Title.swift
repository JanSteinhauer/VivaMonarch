//
//  Title.swift
//  VivaMonarch
//
//  Created by Jan Steinhauer on 3/31/24.
//
import SwiftUI
import Observation

@Observable
class Title {

    var titleText: String = ""
    var isTitleFinished: Bool = false
    var finalTitle: String = "Welcome to Viva Monarch"
}

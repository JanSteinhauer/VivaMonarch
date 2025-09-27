//
//  HubCard.swift
//  VivaMonarch
//
//  Created by Steinhauer, Jan on 27.09.25.
//

import SwiftUI

struct HubCard: View {
    let image: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack {
                Image(image)
                    .resizable()
                    .frame(width: 140, height: 140)
                    .clipShape(Circle())
                Text(title)
            }
            .cornerRadius(15)
        }
        .buttonStyle(.plain)
        .padding()
    }
}

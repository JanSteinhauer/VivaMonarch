//
//  SpeciesChartBlock.swift
//  VivaMonarch
//
//  Created by Steinhauer, Jan on 27.09.25.
//

import SwiftUI

struct SpeciesChartBlock: View {
    let title: String
    let data: [PopulationData]

    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: 20))
                .padding(.top)
            PopulationChartView(data: data)
                .frame(height: 100)
        }
    }
}

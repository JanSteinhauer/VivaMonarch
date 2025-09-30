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
    let tint: Color

    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Spacer()
                Text(title)
                    .font(.system(size: 45, weight: .bold))
                    .padding(.horizontal, 8)
                Spacer()
            }
            PopulationChartView(data: data, tint: tint)
                .frame(height: 130)
        }
        .padding(6)
    }
}

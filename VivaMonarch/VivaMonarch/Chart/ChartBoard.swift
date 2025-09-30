//
//  ChartBoard.swift
//  VivaMonarch
//
//  Created by Steinhauer, Jan on 27.09.25.
//

import SwiftUI

struct ChartBoardView: View {
    @Binding var selectedChart: ChartType
    let monarch: [PopulationData]
    let whale:   [PopulationData]
    let turtle:  [PopulationData]
    let condor:  [PopulationData]

    var body: some View {
        VStack {
            switch selectedChart {
            case .population:
                Text("Population Over Years")
                    .font(.system(size: 40))
                    .padding(.top)
                VStack {
                    HStack {
                        SpeciesChartBlock(title: "Monarch Butterfly", data: monarch, tint: .orange)
                        SpeciesChartBlock(title: "Gray Whale", data: whale, tint: .blue)
                    }
                    HStack {
                        SpeciesChartBlock(title: "Sea Turtle (Canaveral nests)", data: turtle, tint: .green)
                        SpeciesChartBlock(title: "California Condor", data: condor, tint: .purple)
                    }
                }
                .padding(.bottom)

            case .migration:
                Text("Migration Distance by Region")
                    .font(.system(size: 40))
                    .padding(.top)
                MigrationChartView()
                    .frame(height: 300)

            case .credits:
                Image("CreditsImage")
                    .frame(height: 300)

            case .butterflyhub:
                Text("Monarch Butterfly Population Over Years")
                    .font(.system(size: 40))
                    .padding(.top)
                PopulationChartView(data: monarch)
                    .frame(height: 300)

            case .none:
                EmptyView()
            }

            Button {
                selectedChart = .none
            } label: {
                Text("Back")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

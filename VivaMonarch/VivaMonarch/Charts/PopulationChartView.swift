//
//  PopulationChartView.swift
//  VivaMonarch
//
//  Created by Steinhauer, Jan on 11/10/24.
//
import SwiftUI
import Charts

struct PopulationData: Identifiable {
    let id = UUID()
    let year: Int
    let population: Double
}

struct PopulationChartView: View {
    let data : [PopulationData]

    @State private var selectedDataID: UUID?
       @State private var showAllLabels = false

    
    private var maxPopulation: Double {
            data.map { $0.population }.max() ?? 6.5
        }
    
       var body: some View {
           VStack {

               Chart(data) { item in
                   LineMark(
                       x: .value("Year", Double(item.year)),
                       y: .value("Population", item.population)
                   )
                   .foregroundStyle(.orange)
                   .interpolationMethod(.catmullRom)
                   .symbol(.circle)
                   .symbolSize(50)
                   .opacity(selectedDataID == nil || selectedDataID == item.id ? 1 : 0.5)

               }
               .chartXAxis {
                   AxisMarks(values: Array(2016...2023)) { value in
                       AxisValueLabel("\(Int(value.index))")
                   }
               }


               .chartXScale(domain: 2016...2023) // Added this line
               .chartYScale(domain: 0...(maxPopulation-8))
               .frame(width: 300, height: 110)
               .padding()
           }
       }

   }

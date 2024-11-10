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
    let data = [
        PopulationData(year: 2016, population: 3.06),
        PopulationData(year: 2017, population: 2.91),
        PopulationData(year: 2018, population: 3.05),
        PopulationData(year: 2019, population: 2.83),
        PopulationData(year: 2020, population: 2.10),
        PopulationData(year: 2021, population: 2.84),
        PopulationData(year: 2022, population: 2.10),
        PopulationData(year: 2023, population: 1.92)
    ]

    @State private var selectedDataID: UUID?
       @State private var showAllLabels = false

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
                   AxisMarks(values: Array(2016...2023))
               }
               .chartXScale(domain: 2016...2023) // Added this line
               .chartYScale(domain: 0...6.5)
               .frame(width: 500, height: 300)
               .padding()
           }
       }

   }

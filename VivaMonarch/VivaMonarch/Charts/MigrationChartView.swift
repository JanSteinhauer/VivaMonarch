//
//  MigrationChartView.swift
//  VivaMonarch
//
//  Created by Steinhauer, Jan on 11/10/24.
//

import SwiftUI
import Charts
import RealityKit

struct MigrationData: Identifiable {
    let id = UUID()
    let region: String
    let distance: Double // In kilometers
}

struct MigrationChartView: View {
    let data = [
        MigrationData(region: "Southern Canada", distance: 4000),
        MigrationData(region: "Northern USA", distance: 3500),
        MigrationData(region: "Central USA", distance: 2500),
        MigrationData(region: "Southern USA", distance: 1500),
        MigrationData(region: "Northern Mexico", distance: 1000)
    ]
    @State private var selectedDataID: UUID?
       @State private var showAllLabels = false

       var body: some View {
           VStack {
               Toggle("Show All Labels", isOn: $showAllLabels)
                   .padding()

               Chart(data) { item in
                   BarMark(
                       x: .value("Region", item.region),
                       y: .value("Distance", item.distance)
                   )
                   .foregroundStyle(selectedDataID == nil || selectedDataID == item.id ? .blue : .blue.opacity(0.5))
                   .annotation(position: .top) {
                       if showAllLabels || selectedDataID == item.id {
                           Text("\(item.distance, specifier: "%.0f") km")
                               .font(.caption)
                               .padding(5)
                               .background(Color.white.opacity(0.8))
                               .cornerRadius(5)
                               .shadow(radius: 5)
                       }
                   }
               }
               .chartYAxis {
                   AxisMarks(position: .leading)
               }
               .frame(height: 300)
               .padding()
              
           }
       }

      
   }

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
    
    var customColor: Color {
        Color(red: 170/255.0, green: 121/255.0, blue: 66/255.0)
    }
    
    @State private var selectedDataID: UUID?
       
       var body: some View {
           VStack {
               Chart(data) { item in
                   BarMark(
                       x: .value("Region", item.region),
                       y: .value("Distance", item.distance)
                   )
                   .foregroundStyle(selectedDataID == nil || selectedDataID == item.id ? customColor : customColor.opacity(0.5))
               }
               .chartYAxis {
                   AxisMarks(position: .leading)
               }
               .frame(height: 300)
               .padding()
              
           }
       }

      
   }

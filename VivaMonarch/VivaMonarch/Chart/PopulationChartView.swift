//
//  PopulationChartView.swift
//  VivaMonarch
//
//  Created by Steinhauer, Jan on 11/10/24.
//

import SwiftUI
import Charts
import Foundation

enum PopulationChartStyle: String, CaseIterable, Identifiable {
    case line, area, bar
    var id: String { rawValue }
}

struct PopulationChartView: View {
    let data: [PopulationData]
    var title: String? = nil
    var tint: Color = .orange

    @State private var style: PopulationChartStyle = .area

    // Explicit types help the type-checker
    private var minYear: Int { data.map(\.year).min() ?? 2016 }
    private var maxYear: Int { data.map(\.year).max() ?? 2024 }
    private var maxPop: Double {
        let m: Double = data.map { Double($0.population) }.max() ?? 1
        return m * 1.10
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let title { Text(title).font(.headline) }

            Picker("Style", selection: $style) {
                ForEach(PopulationChartStyle.allCases) { s in
                    Text(s.rawValue.capitalized).tag(s)
                }
            }
            .pickerStyle(.segmented)

            // Split heavy Chart builders into tiny, dedicated views
            Group {
                switch style {
                case .line:
                    PopulationLineChart(data: data, tint: tint,
                                        minYear: minYear, maxYear: maxYear, maxPop: maxPop)
                case .area:
                    PopulationAreaChart(data: data, tint: tint,
                                        minYear: minYear, maxYear: maxYear, maxPop: maxPop)
                case .bar:
                    PopulationBarChart(data: data, tint: tint,
                                       minYear: minYear, maxYear: maxYear, maxPop: maxPop)
                }
            }
            .frame(minHeight: 160)
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Subcharts (small, compiler-friendly)

private struct PopulationLineChart: View {
    let data: [PopulationData]
    let tint: Color
    let minYear: Int
    let maxYear: Int
    let maxPop: Double

    var body: some View {
        Chart {
            ForEach(data) { item in
                LineMark(
                    x: .value("Year", item.year),
                    y: .value("Population", item.population)
                )
                .interpolationMethod(.catmullRom)
                .symbol(.circle)
                .foregroundStyle(tint)
                .lineStyle(.init(lineWidth: 2))
            }
        }
        .chartCommon(minYear: minYear, maxYear: maxYear, maxPop: maxPop)
    }
}

private struct PopulationAreaChart: View {
    let data: [PopulationData]
    let tint: Color
    let minYear: Int
    let maxYear: Int
    let maxPop: Double

    var body: some View {
        Chart {
            ForEach(data) { item in
                AreaMark(
                    x: .value("Year", item.year),
                    y: .value("Population", item.population)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(
                    .linearGradient(
                        colors: [tint.opacity(0.55), tint.opacity(0.12)],
                        startPoint: .top, endPoint: .bottom
                    )
                )
            }
            ForEach(data) { item in
                LineMark(
                    x: .value("Year", item.year),
                    y: .value("Population", item.population)
                )
                .interpolationMethod(.catmullRom)
                .symbol(.circle)
                .foregroundStyle(tint)
                .lineStyle(.init(lineWidth: 2))
            }
        }
        .chartCommon(minYear: minYear, maxYear: maxYear, maxPop: maxPop)
    }
}

private struct PopulationBarChart: View {
    let data: [PopulationData]
    let tint: Color
    let minYear: Int
    let maxYear: Int
    let maxPop: Double

    var body: some View {
        Chart {
            ForEach(data) { item in
                BarMark(
                    x: .value("Year", item.year),
                    y: .value("Population", item.population)
                )
                .cornerRadius(6)
                .foregroundStyle(tint)
            }
        }
        .chartCommon(minYear: minYear, maxYear: maxYear, maxPop: maxPop)
    }
}

// MARK: - Shared axis & styling
private func compact(_ v: Double) -> String {
    if v >= 1_000_000 { return "\(Int((v/1_000_000).rounded()))M" }
    if v >= 1_000    { return "\(Int((v/1_000).rounded()))K" }
    return "\(Int(v.rounded()))"
}

private extension View {
    func chartCommon(minYear: Int, maxYear: Int, maxPop: Double) -> some View {
        self
            .chartXAxis {
                AxisMarks(position: .bottom, values: Array(minYear...maxYear)) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let y = value.as(Int.self) { Text("\(y)") }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in         // <-- name it `value`
                    AxisGridLine()
                    AxisTick()
                    if let v = value.as(Double.self) {
                        AxisValueLabel(compact(v))               // <-- pass a String
                        // or: AxisValueLabel { Text(compact(v)) }
                    }
                }
            }
            .chartXScale(domain: Double(minYear)...Double(maxYear))
            .chartYScale(domain: 0...maxPop)
            .chartPlotStyle { plot in
                plot.background(.ultraThinMaterial.opacity(0.4))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 4)
    }
}


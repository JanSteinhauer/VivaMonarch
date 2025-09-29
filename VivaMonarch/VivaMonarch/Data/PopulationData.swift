//
//  PopulationData.swift
//  VivaMonarch
//
//  Created by Steinhauer, Jan on 27.09.25.
//

import SwiftUI

struct PopulationData: Identifiable, Hashable {
    let year: Int
    let population: Int

    // Use year as a stable identifier for charting
    var id: Int { year }
}

enum Datasets {
    // WESTERN MONARCH THANKSGIVING COUNT (total butterflies)
    // 2024 is a mid-season value (not directly comparable to final totals).
    static let monarch: [PopulationData] = [
        PopulationData(year: 2016, population: 298_464),
        PopulationData(year: 2017, population: 192_624),
        PopulationData(year: 2018, population: 27_721),
        PopulationData(year: 2019, population: 29_436),
        PopulationData(year: 2020, population: 1_914),
        PopulationData(year: 2021, population: 247_237),
        PopulationData(year: 2022, population: 335_479),
        PopulationData(year: 2023, population: 233_394),
        PopulationData(year: 2024, population: 9_119) // mid-season
    ]

    // EASTERN NORTH PACIFIC GRAY WHALES (seasonal abundance ~= total population)
    // Mapping: 2016→2015/16; 2019 & 2020→2019/20; 2021 & 2022→2021/22;
    // 2023→2022/23; 2024→2023/24 point estimate.
    static let whale: [PopulationData] = [
        PopulationData(year: 2016, population: 26_960), // 2015/16
        PopulationData(year: 2017, population: 26_960), // carry nearest published season
        PopulationData(year: 2018, population: 26_960), // carry nearest published season
        PopulationData(year: 2019, population: 20_580), // 2019/20
        PopulationData(year: 2020, population: 20_580), // 2019/20
        PopulationData(year: 2021, population: 16_650), // 2021/22
        PopulationData(year: 2022, population: 16_650), // 2021/22
        PopulationData(year: 2023, population: 14_525), // 2022/23 (nearest public figure)
        PopulationData(year: 2024, population: 19_260)  // 2023/24 rebound estimate
    ]

    // SEA TURTLES at Canaveral National Seashore, FL (total nests = proxy index)
    static let turtle: [PopulationData] = [
        PopulationData(year: 2016, population: 5_437),
        PopulationData(year: 2017, population: 12_315),
        PopulationData(year: 2018, population: 4_539),
        PopulationData(year: 2019, population: 13_308),
        PopulationData(year: 2020, population: 7_888),
        PopulationData(year: 2021, population: 8_044),
        PopulationData(year: 2022, population: 12_547),
        PopulationData(year: 2023, population: 16_812),
        PopulationData(year: 2024, population: 7_404)
    ]

    // CALIFORNIA CONDOR (world total = wild + captive)
    static let condor: [PopulationData] = [
        PopulationData(year: 2016, population: 446),
        PopulationData(year: 2017, population: 463),
        PopulationData(year: 2018, population: 488),
        PopulationData(year: 2019, population: 518),
        PopulationData(year: 2020, population: 504),
        PopulationData(year: 2021, population: 537),
        PopulationData(year: 2022, population: 561),
        PopulationData(year: 2023, population: 561),
        PopulationData(year: 2024, population: 569)
    ]
}

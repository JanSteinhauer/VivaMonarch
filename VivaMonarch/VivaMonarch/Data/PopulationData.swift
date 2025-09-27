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
    static let monarch = [
        PopulationData(year: 2016, population: 84_000_000),
        PopulationData(year: 2017, population: 96_600_000),
        PopulationData(year: 2018, population: 186_900_000),
        PopulationData(year: 2019, population: 141_400_000),
        PopulationData(year: 2020, population: 99_300_000),
        PopulationData(year: 2021, population: 59_640_000),
        PopulationData(year: 2022, population: 58_800_000),
        PopulationData(year: 2023, population: 18_900_000),
    ]
    static let whale = [
        PopulationData(year: 2016, population: 27_000),
        PopulationData(year: 2017, population: 26_500),
        PopulationData(year: 2018, population: 26_000),
        PopulationData(year: 2019, population: 21_000),
        PopulationData(year: 2020, population: 15_000),
        PopulationData(year: 2021, population: 14_000),
        PopulationData(year: 2022, population: 15_000),
        PopulationData(year: 2023, population: 19_000),
    ]
    static let turtle = [
        PopulationData(year: 2016, population: 34_000),
        PopulationData(year: 2017, population: 35_000),
        PopulationData(year: 2018, population: 36_000),
        PopulationData(year: 2019, population: 35_000),
        PopulationData(year: 2020, population: 34_000),
        PopulationData(year: 2021, population: 35_000),
        PopulationData(year: 2022, population: 36_000),
        PopulationData(year: 2023, population: 34_000),
    ]
    static let condor = [
        PopulationData(year: 2016, population: 446),
        PopulationData(year: 2017, population: 463),
        PopulationData(year: 2018, population: 488),
        PopulationData(year: 2019, population: 518),
        PopulationData(year: 2020, population: 504),
        PopulationData(year: 2021, population: 537),
        PopulationData(year: 2022, population: 561),
        PopulationData(year: 2023, population: 580),
    ]
}


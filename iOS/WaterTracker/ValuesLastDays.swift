//
//  WaterStatisticsView.swift
//  personal_tracker
//
//  Created by Bastian Radloff on 20.02.21.
//

import SwiftUI
import HealthKit

struct ValuesLastDaysView: View {
    let data: Array<(String, Double)>
    let key: String
    let color: Color
    
    var body: some View {
        VStack{
            BarplotTitleView(title: key.capitalizingFirstLetter())
            BarplotView(data: data,
                        color: color)
        }.padding(.horizontal, 5)
    }
}


struct BarplotView: View {
    var data: Array<(String, Double)>
    let color: Color

    var body: some View {
        let bars: Array<Bar> = createBars(data: data, color: color)
        BarChartView(bars: bars)
    }
}

private func createBars(data: Array<(String, Double)>, color: Color) -> Array<Bar> {
        
    var bars: Array<Bar> = []
//    let days: Array<String> = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
//
//    let date = Date()
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "EEEE"
//    let dayInWeek = dateFormatter.string(from:date)
//    let today = String(dayInWeek.prefix(3))
//    let indexDays = days.firstIndex(of: today)! + 1
//    let lastDays = days[indexDays...] + days[..<indexDays]

    for datapoint in data {
        let bar: Bar = Bar(id: UUID(),
                           value: datapoint.1,
                           label: datapoint.0,
                           color: color)
        bars.append(bar)
    }
    return bars
}

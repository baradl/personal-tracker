//
//  WeightHistoryPlotView.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 21.03.21.
//

import SwiftUI

struct HistoryPlotView: View {
    @ObservedObject var dataModel: DataModel
//    @State var on = true
//    let style: ChartStyle = getLineChartStyle()
//    let dateFormatter = getDateFormatter(format: "d.m.y")
    
    var body: some View {
        let weightsLastSixMonths : Array<(Date, Double)>? = Array(dataModel.weights.filter{weight in
            let startLastSixMonth = getLastSixMonthsStart(date: Date())
            return weight.timestamp >= startLastSixMonth
        }.map{weight in
            return (weight.timestamp, weight.weight)
        }.reversed())
        
        GeometryReader{geometry in
            LineChartView(data: weightsLastSixMonths ?? [(Date(), 0.0)])
                .frame(width: geometry.size.width,
                       height: geometry.size.height)
        }
    }
}




//func weightsLastSixMonths(weights: Array<Weight>) -> Array<Double> {
//    let startLastSixMonth = getLastSixMonthsDate()
//}

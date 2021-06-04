//
//  DashboardMetricHistory.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 23.03.21.
//

import SwiftUI

struct DailySumHistoryView : View {
    let metricName: String
    let metricColor: Color
    let metricUnit: String
    
    let maxString: String
    let avgString: String
    let days: Array<(String, Double)>
    let weeks: Array<(String, Double)>
    let months: Array<(String, Double)>
        
    var body: some View {
        GeometryReader {geometry in
            VStack{
                HStack{
                    SingleMetricView(title: "Max", valueString: maxString, unitString: metricUnit)
                    SingleMetricView(title: "Average", valueString: avgString, unitString: metricUnit)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.09)
                .padding(.vertical, 10)
                
                Divider()
                
                VStack{
                    BarplotTitleView(title: "Days")
                    BarplotView(data: days, color: metricColor)
                }
                .padding(.all, 5)
                
                VStack{
                    BarplotTitleView(title: "Weeks")
                    BarplotView(data: weeks, color: metricColor)
                }
                .padding(.all, 5)
                
                VStack{
                    BarplotTitleView(title: "Months")
                    BarplotView(data: months, color: metricColor)
                }
                .padding(.all, 5)
            }.navigationBarTitle("\(metricName.capitalizingFirstLetter()) History")
        }
    }
}

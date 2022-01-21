//
//  WaterAnimationView.swift
//  personal_tracker
//
//  Created by Bastian Radloff on 20.02.21.
//
import SwiftUI
import HealthKit

struct ValueTodayView: View {
    @ObservedObject var dataModel: DataModel
    
    var body: some View{
        GeometryReader{ geometry in
            HStack(alignment: .center) {
                NavigationLink(destination: DailySumHistoryView(metricName: "water",
                                                                metricColor: Color("WaterColor"),
                                                                metricUnit: "ml",
                                                                maxString: String(format: "%.0f", dataModel.dailySumData.historyMetrics.water.max),
                                                                avgString: String(format: "%.0f", dataModel.dailySumData.historyMetrics.water.avg),
                                                                days: dataModel.dailySumData.days.water,
                                                                weeks: dataModel.dailySumData.weeks.water,
                                                                months: dataModel.dailySumData.months.water),
                               label: {
                                ValueAnimationView(title: "water",
                                                   value: Int(dataModel.dailySumData.today.water),
                                                   color: Color("WaterColor"),
                                                   unit: "ml")
                               })
                Divider()
                    .background(Color(.lightGray))
                    .padding(.vertical, 10)
                NavigationLink(destination: DailySumHistoryView(metricName: "caffeine",
                                                                metricColor: Color("CaffeineColor"),
                                                                metricUnit: "mg",
                                                                maxString: String(format: "%.0f", dataModel.dailySumData.historyMetrics.caffeine.max),
                                                                avgString: String(format: "%.0f", dataModel.dailySumData.historyMetrics.caffeine.avg),
                                                                days: dataModel.dailySumData.days.caffeine,
                                                                weeks: dataModel.dailySumData.weeks.caffeine,
                                                                months: dataModel.dailySumData.months.caffeine),
                               label: {
                                ValueAnimationView(title: "caffeine",
                                                          value: Int(dataModel.dailySumData.today.caffeine),
                                                          color: Color("CaffeineColor"),
                                                          unit: "mg")
                               })
            }
        }
    }
}

struct ValueAnimationView : View {
    let title: String
    let value: Int
    let color: Color
    let unit: String
        
    var body: some View {
        
        GeometryReader{ geometry in
            VStack(alignment: .center){
                 Text(title.capitalizingFirstLetter())
                    .foregroundColor(Color("TextColor"))
                    .padding()
                 Spacer()
                 Text("\(value)\(unit)")
                    .foregroundColor(color)
                    .font(.system(size: 40, weight: .light))
                 Spacer()
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(ComponentBackgroundColor())
            .overlay(RoundedRectangle(cornerRadius: 10.0).stroke(color))
//            .border(color)
//            .cornerRadius(10.0)
        }
        .padding(.all, 15)
    }
}

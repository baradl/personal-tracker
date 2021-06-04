//
//  ActivityMetricView.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 16.03.21.
//

import SwiftUI
import HealthKitUI
import HealthKit


struct ActivityView: View {
    let activitySummary: HKActivitySummary?
    
    var body: some View {
        GeometryReader {geometry in
            let height = geometry.size.height * 0.5
            HStack(alignment: .bottom){
                HStack{
                    AcitivityMetricView(metricColor: Color("BaseRed"),
                                        metricName: "Bewegen",
                                        value: Int(activitySummary?.activeEnergyBurned.doubleValue(for: HKUnit.init(from: "kcal")) ?? 0),
                                        unit: "kcal")
                    Divider()
                        .background(Color(.lightGray))
                        .padding(.vertical, 10)
                    AcitivityMetricView(metricColor: Color("BaseGreen"),
                                        metricName: "Training",
                                        value: Int(activitySummary?.appleExerciseTime.doubleValue(for: HKUnit.init(from: "min")) ?? 0),
                                        unit: "Min.")
                        .frame(width: 0.25 * geometry.size.width,
                               height: height)
                    Divider()
                        .background(Color(.lightGray))
                        .padding(.vertical, 10)
                    AcitivityMetricView(metricColor: Color("BaseBlue"),
                                        metricName: "Stehen",
                                        value: Int(activitySummary?.appleStandHours.doubleValue(for: HKUnit.init(from: "count")) ?? 0),
                                        unit: "Std.")
                        .frame(width: 0.18 * geometry.size.width,
                               height: height)
                }
                .frame(width: geometry.size.width * 0.75,
                       height: height)
                .padding(.leading, 10)
                ActivityRingView(activitySummary: activitySummary, size: 60)
                    .frame(width: 0.2 * geometry.size.width,
                           height: geometry.size.height,
                           alignment: .bottom)
                    .offset(y: -height * 0.15)
            }
            .frame(width: geometry.size.width,
                   height: height,
                   alignment: .bottom)
            .background(ComponentBackgroundColor())
            .cornerRadius(15)
        }.padding(.all, 5)
    }
}


struct AcitivityMetricView: View {
    var metricColor: Color
    var metricName: String
    var value: Int
    var unit: String
    
//    let width: CGFloat
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(metricName)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(metricColor)
                Spacer()
            }.padding(.bottom,3)
            HStack{
                Text("\(value)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color("TextColor"))
                Text(unit)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color(.lightGray))
            }
        }
    }
}

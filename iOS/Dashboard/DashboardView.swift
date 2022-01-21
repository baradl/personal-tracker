//
//  DashboardView.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 15.03.21.
//

import SwiftUI
import HealthKit

struct DashboardView: View {
    @Binding var hkManager: HKManager
    @ObservedObject var dataModel: DataModel
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                NavigationLink(destination: ActivitySummaryView(activitySummary: dataModel.activitySummary),
                               label: {
                                ActivityView(activitySummary: dataModel.activitySummary.summaries.last ?? nil)
                                    .offset(y: geometry.size.height * 0.07)
                               })
                
//                DashboardMetricsView(hkManager: $hkManager,
//                                     dataModel: dataModel)
//                    .offset(y: -geometry.size.height * 0.17)
            }.frame(width: geometry.size.width,
                    height: geometry.size.height)
        }
    }
}

//struct DashboardMetricsView : View {
//    @Binding var hkManager : HKManager
//    @ObservedObject var dataModel: DataModel
//
//    var body: some View {
//        GeometryReader{geometry in
//            VStack{
//                HStack{
//                    NavigationLink(destination: CalorieHistoryView(dataModel: dataModel),
//                                   label: {
//                                    MetricView(metricName: "Basal Calories",
//                                                        metricValueString: String(format: "%.0f", dataModel.dailySumData.today.basalEnergy),
//                                                               metricSymbolPath: "flame",
//                                                               metricColor: Color("BrightOrange"),
//                                                               metricUnit: "kcal")
//                                   })
//                    NavigationLink(destination: CalorieHistoryView(dataModel: dataModel),
//                                   label: {
//                                    MetricView(metricName: "All Calories",
//                                                               metricValueString: String(format: "%.0f", dataModel.dailySumData.today.basalEnergy + dataModel.dailySumData.today.activeEnergy),
//                                                               metricSymbolPath: "flame",
//                                                               metricColor: Color("BrightOrange"),
//                                                               metricUnit: "kcal")
//                                   })
//                }
//                HStack{
//                    NavigationLink(destination: DailySumHistoryView(metricName: "Steps",
//                                                                    metricColor: Color("BaseBlue"),
//                                                                    metricUnit: "",
//                                                                    maxString: String(format: "%.0f", dataModel.dailySumData.historyMetrics.steps.max),
//                                                                    avgString: String(format: "%.0f", dataModel.dailySumData.historyMetrics.steps.avg),
//                                                                    days: dataModel.dailySumData.days.steps,
//                                                                    weeks: dataModel.dailySumData.weeks.steps,
//                                                                    months: dataModel.dailySumData.months.steps),
//                                   label: {
//                                    MetricView(metricName: "Steps",
//                                                        metricValueString: String(format: "%.0f", dataModel.dailySumData.today.steps),
//                                                        metricSymbolPath: "footstep",
//                                                        metricColor: Color("BaseBlue"),
//                                                        metricUnit: "steps")
//                                   })
//                    NavigationLink(destination: DailySumHistoryView(metricName: "Dietary Calories",
//                                                                    metricColor: Color("BaseGreen"),
//                                                                    metricUnit: "kcal",
//                                                                    maxString: String(format: "%.0f", dataModel.dailySumData.historyMetrics.consumedEnergy.max),
//                                                                    avgString: String(format: "%.0f", dataModel.dailySumData.historyMetrics.consumedEnergy.avg),
//                                                                    days: dataModel.dailySumData.days.consumedEnergy,
//                                                                    weeks: dataModel.dailySumData.weeks.consumedEnergy,
//                                                                    months: dataModel.dailySumData.months.consumedEnergy),
//                                   label: {
//                                    MetricView(metricName: "Dietary Calories",
//                                               metricValueString: String(format: "%.0f", dataModel.dailySumData.today.consumedEnergy),
//                                               metricSymbolPath: "diet",
//                                               metricColor: Color("BaseGreen"),
//                                               metricUnit: "kcal")
//                                   })
//                }
//                HStack{
//                    NavigationLink(destination: RunningHistoryView(dataModel: dataModel,
//                                                                   hkManager: $hkManager),
//                                   label: {
//                                    MetricView(metricName: "Running Distance",
//                                               metricValueString: String(format: "%.1f", dataModel.workoutData.runningDistanceThisMonth),
//                                              metricSymbolPath: "running",
//                                              metricColor: BaseRed,
//                                              metricUnit: "km")
//                                   })
//                    NavigationLink(destination: WorkoutHistoryView(dataModel: dataModel,
//                                                                   hkManager: $hkManager),
//                                   label: {
//                                    MetricView(metricName: "Number Workouts",
//                                               metricValueString: String(dataModel.workoutData.workoutsPerMonth.last?.1.count ?? 0),
//                                                metricSymbolPath: "barbell",
//                                                metricColor: Color("BaseRed"),
//                                                metricUnit: "workouts")
//                                   })
//                }
//            }
//            .frame(width: geometry.size.width, height: 1.27 * geometry.size.height, alignment: .top)
//        }.padding(.horizontal, 5)
//    }
//}

//struct MetricView: View {
//    var metricName: String
//    var metricValueString: String
//    var metricSymbolPath: String
//    var metricColor: Color
//    var metricUnit: String
//
//    var body: some View {
//        GeometryReader{ geometry in
//            VStack(alignment: .leading){
//                HStack{
//                    Image(metricSymbolPath)
//                        .renderingMode(.original)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 18, height: 18)
//                    Text(metricName)
//                        .font(.system(size: 15, weight: .bold))
//                        .foregroundColor(metricColor)
//                }
//                .padding(.horizontal, 10)
//                .padding(.top, 5)
//                HStack{
//                    Text(metricValueString)
//                        .font(.system(size: 18, weight: .bold))
//                        .foregroundColor(Color("TextColor"))
//                    Text(metricUnit)
//                        .font(.system(size: 18, weight: .bold))
//                        .foregroundColor(Color(.lightGray))
//                    Spacer()
//                }
//                .padding(.horizontal, 10)
//                .padding(.bottom, 5)
//            }
//            .frame(width: geometry.size.width,
//                   height: geometry.size.height)
//            .background(ComponentBackgroundColor())
//            .cornerRadius(15.0)
//        }
//    }
//}

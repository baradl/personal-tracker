//
//  ActivitySummaryView.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 25.03.21.
//


import SwiftUI
import HealthKit

struct ActivitySummaryView : View {
    let activitySummary: ActivitySummary
    
    var body: some View {
        GeometryReader{geometry in
            VStack{
                ActivityHistoryView(activitySummary: activitySummary)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                    .background(ComponentBackgroundColor())
                ActivityRingView(activitySummary: activitySummary.summaries.last ?? nil,
                                 size: geometry.size.height * 0.3)
                    .padding(.all, 10)
                Divider()
                    .foregroundColor(Color(.lightGray))
                    .padding(.horizontal, 10)
                ActivityMetricGoalView(title: "Active Energy",
                                       current: activitySummary.summaries.last??.activeEnergyBurned.doubleValue(for: HKUnit(from: "kcal")) ?? 0,
                                       goal: activitySummary.summaries.last??.activeEnergyBurnedGoal.doubleValue(for: HKUnit(from: "kcal")) ?? 0,
                                       color: Color("BaseRed"),
                                       unit: "kcal")
                ActivityMetricGoalView(title: "Exercise Minutes",
                                       current: activitySummary.summaries.last??.appleExerciseTime.doubleValue(for: HKUnit(from: "min")) ?? 0,
                                       goal: activitySummary.summaries.last??.appleExerciseTimeGoal.doubleValue(for: HKUnit(from: "min")) ?? 0,
                                       color: Color("BaseGreen"),
                                       unit: "Min")
                ActivityMetricGoalView(title: "Standing Hours",
                                       current: activitySummary.summaries.last??.appleStandHours.doubleValue(for: HKUnit(from: "count")) ?? 0,
                                       goal: activitySummary.summaries.last??.appleStandHoursGoal.doubleValue(for: HKUnit(from: "count")) ?? 0,
                                       color: Color("BaseBlue"),
                                       unit: "Std.")
                
                StandingHourView(activitySummary: activitySummary)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.2)
            }
            .navigationTitle("Activity Summary")
        }
    }
}


struct ActivityHistoryView : View {
    let activitySummary: ActivitySummary
    
    let date: Date = Date()
    let dateFormatter = getDateFormatter(format: "EEEE")
    let calendar = Calendar.current
    
    var body: some View {
        GeometryReader{geometry in
            let dates = getWeekDates(date: date).dates
            HStack{
                ForEach(0 ..< 7, id: \.self){index in
                    let summary = activitySummary.getWeeksSummaries(date: date)[index]
                    let weekDay = dates[index]
                    VStack{
                        Text(dateFormatter.string(from: weekDay).prefix(3))
                            .font(.system(size: 10, weight: .light))
                            .foregroundColor(Color("TextColor"))
                            .padding(.top, 3)
                        ActivityRingView(activitySummary: summary,
                                         size: geometry.size.height * 0.6)
                    }.padding(.horizontal, 2)
                }
            }.padding(.horizontal, 5)
        }
    }
}


struct ActivityMetricGoalView : View {
    let title: String
    let current: Double
    let goal: Double
    let color: Color
    let unit: String
    
    var body: some View {
        GeometryReader{geometry in
            VStack{
                HStack(alignment: .top){
                    Text(title)
                        .font(.system(size: 17, weight: .light))
                        .foregroundColor(Color("TextColor"))
                    Spacer()
                }
                HStack(alignment: .bottom){
                    Text("\(String(format: "%.0f", current))/\(String(format: "%.0f", goal))")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(color)
                    Text(unit)
                        .font(.system(size: 25, weight: .light))
                        .foregroundColor(Color(.lightGray))
                        .offset(y: -2)
                    Spacer()
                }
            }.frame(width: geometry.size.width, height: geometry.size.height)
        }.padding(.horizontal, 10)
    }
}

struct StandingHourView : View {
    let activitySummary: ActivitySummary
    var body: some View {
        GeometryReader{geometry in
            let standingHoursWidth: CGFloat = geometry.size.width * 0.035
            let standingHoursHeight: CGFloat = geometry.size.height * 0.7
            VStack{
                HStack(alignment: .top){
                    ForEach(0 ..< activitySummary.standingHours.count, id: \.self){hour in
                        let status = activitySummary.standingHours[hour]
                        VStack{
                            Rectangle()
                                .foregroundColor(status != -1 ? (status == 1 ? Color("BaseBlue") : Color("DarkBlue")) : Color.black)
                                .frame(width: standingHoursWidth, height: standingHoursHeight)
                                .cornerRadius(5.0)
                                .padding(.horizontal, -3)
                                .padding(.bottom, -5)
                            if hour % 3 == 0 {
                                Text(String(format: "%02d", hour))
                                    .font(.system(size: 8, weight: .light))
                                    .padding(.horizontal, -2)
                            }else{
                                Spacer()
                            }
                        }
                    }
                }
                .frame(width: standingHoursWidth, height: standingHoursHeight)
                .padding(.horizontal, 10)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(ComponentBackgroundColor())
            .cornerRadius(10.0)
        }.padding(.all, 10)
    }
}

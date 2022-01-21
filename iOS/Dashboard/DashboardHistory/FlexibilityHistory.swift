//
//  FlexibilityHistory.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 21.01.22.
//
import SwiftUI
import HealthKit

struct FlexibilityHistoryView: View {
    let flexibilityWorkouts: Array<HKWorkout>
    var body: some View {
        GeometryReader {geometry in
            let lastDaysActive: Array<(day: String, isActive: Bool)> = [("Mon", false),("Tue", true),("Wed", true),("Thu", false),("Fri", true),("Sat", true), ("Sun", false)]
            VStack{
                HStack(alignment: .top){
                    Spacer()
                    ForEach(lastDaysActive, id: \.day){(day, isActive) in
                        VStack(alignment: .center, spacing: 10){
                            Text(day)
                                .font(.system(size: 20, weight: .light))
                            Image(systemName: isActive ? "checkmark.square.fill" : "square")
                                .foregroundColor(isActive ? Color("LightRed"):  Color.secondary)
                                .frame(width: 30, height: 30)
                               
                        }
                        Spacer()
                    }
                }
                Divider()
                BarplotTitleView(title: "Weeks")
                BarplotView(data: getNumberWeeklyWorkouts(workouts: flexibilityWorkouts), color: Color("LightRed"))
                BarplotTitleView(title: "Months")
                BarplotView(data: getNumberMonthlyWorkouts(workoutsPerMonth: getWorkoutsPerMonth(workouts: flexibilityWorkouts)),
                            color: Color("LightRed"))
            }.navigationBarTitle("Flexibility History")
        }
    }
}

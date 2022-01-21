//
//  ContentView.swift
//  Shared
//
//  Created by Bastian Radloff on 14.02.21.
//

import SwiftUI
import HealthKit
import HealthKitUI

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//                VStack(alignment: .leading, spacing:10){
//                    ActivityView(activitySummary: nil).padding(.top, 10)
//
//                    TrackerViewCard(bodyweight: 93.5, dateLastWeight: Date(), water: 3500, caffeine: 150)
//                    CalorieMainViewCard(basalCalories:  1200, activityCalories: 800)
//                    MovementMainViewCard(steps: 2400, runningDistance: 12.5, walkingDistance: 23.4, bikingDistance: 101.9)
//                    WorkoutsCardView(strength: 10, runs: 2, cardio: 5)
//                    Spacer()
//                }
//
//            .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
//            .navigationBarTitle("Trackify")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}

struct MainView: View {
    @Binding var hkManager: HKManager
    @ObservedObject var dataModel: DataModel
    var todaysBeverages: UserDefaults
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing:10){
                NavigationLink(destination: ActivitySummaryView(activitySummary: dataModel.activitySummary),
                           label:{
                            ActivityView(activitySummary: dataModel.activitySummary.summaries.last ?? nil)
                            })
                
                
                TrackerViewCard(hkManager: $hkManager, dataModel: dataModel, todaysBeverages: todaysBeverages)
                Divider()
                NavigationLink(
                    destination: CalorieHistoryView(dataModel: dataModel),
                    label: {
                        CalorieMainViewCard(hkManager: $hkManager, dataModel: dataModel)
                    })
                Divider()
                NavigationLink(
                    destination: WorkoutHistoryView(dataModel: dataModel, hkManager: $hkManager),
                    label: {
                        WorkoutsCardView(hkManager: $hkManager, dataModel: dataModel)
                    })
                Divider()
                MovementMainViewCard(hkManager: $hkManager, dataModel: dataModel)
            }
            .frame(width: screenWidth * 0.945, height: screenHeight * 0.83, alignment: .center)
            .navigationBarTitle("Trackify")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear{
            updateUI(dataModel: dataModel, hkManager: hkManager)
            updateActivitySummary(hkManager: hkManager, dataModel: dataModel, timeframe: "all")
            updateWeightTrackerData(hkManager: hkManager,
                                         dataModel: dataModel)
        }
    }
}

struct TestView: View{
    var body: some View {
        Text("Hello World")
    }
}



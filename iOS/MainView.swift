//
//  ContentView.swift
//  Shared
//
//  Created by Bastian Radloff on 14.02.21.
//

import SwiftUI
import HealthKit
import HealthKitUI

struct MainView: View {
    @Binding var hkManager: HKManager
    @ObservedObject var dataModel: DataModel
    var todaysBeverages: UserDefaults
    
    var body: some View {
        GeometryReader{geometry in
            NavigationView{
                VStack(spacing: 10){
                    DashboardView(hkManager: $hkManager,
                                  dataModel: dataModel)
                        .frame(width: geometry.size.width,
                               height: 0.5 * geometry.size.height)

//                    Divider()
//                        .padding(.horizontal, 10)
//                        .foregroundColor(Color(.lightGray))
//                        .offset(y: -geometry.size.height * 0.03)

                    TrackerView(hkManager: $hkManager,
                                dataModel: dataModel,
                                todaysBeverages: todaysBeverages)
                        .frame(width: geometry.size.width,
                               height: 0.5 * geometry.size.height)
                        .offset(y: -geometry.size.height * 0.03)
                }
//                VStack{
//                    NavigationLink(destination: ActivitySummaryView(activitySummary: dataModel.activitySummary),
//                                   label: {
//                                    ActivityView(activitySummary: dataModel.activitySummary.summaries.last ?? nil)
//                                   })
//                    NavigationLink(destination: WeightTrackerView(hkManager: $hkManager,
//                                                           dataModel: dataModel),
//                                   label:{
//                                        TrackerButton(imageString: "body-scale")
//                                    })
//
//                    NavigationLink(destination: WaterTrackerView(hkManager: $hkManager,
//                                                                 dataModel: dataModel,
//                                                                 todaysBeverages: todaysBeverages),
//                                   label:{
//                                        TrackerButton(imageString: "drop")
//                                    })
//
//                }
//                .frame(width: geometry.size.width,
//                       height: geometry.size.height)
                .navigationBarTitle("Trackify")
                
//                .navigationBarItems(trailing: NavigationLink(destination: SettingsView(),
//                                 label: {
//                                  SettingsButton()
//                                 }))
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
}


struct TrackerView : View {
    @Binding var hkManager: HKManager
    @ObservedObject var dataModel: DataModel
    var todaysBeverages: UserDefaults
    
    var body: some View {
        GeometryReader{ geometry in
            VStack{
                HStack(alignment: .bottom){
                    NavigationLink(destination: WeightTrackerView(hkManager: $hkManager,
                                                           dataModel: dataModel),
                                   label:{
                                        TrackerButton(imageString: "body-scale")
                                    })
                    NavigationLink(destination: WaterTrackerView(hkManager: $hkManager,
                                                                 dataModel: dataModel,
                                                                 todaysBeverages: todaysBeverages),
                                   label:{
                                        TrackerButton(imageString: "drop")
                                    })
                }
                HStack(alignment: .bottom){
                    Button{}label: {
                                        TrackerButton(imageString: "barbell")
                                    }
                    Button{}label: {
                                        TrackerButton(imageString: "diet")
                                    }
                }
            }
            .frame(width: geometry.size.width,
                   height: geometry.size.height)
        }.padding(.all, 5)
    }
}


struct TestView: View{
    var body: some View {
        Text("Hello World")
    }
}



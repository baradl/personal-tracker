//
//  personal_trackerApp.swift
//  Shared
//
//  Created by Bastian Radloff on 14.02.21.
//

import SwiftUI
import HealthKit
import PartialSheet
import MapKit

@main
struct personalTrackerApp: App {
    @State var manager = HKManager()
    @ObservedObject var dataModel = DataModel()
    var todaysBeverages = UserDefaults.standard
    let sheetManager: PartialSheetManager = PartialSheetManager()
    let locationManager: CLLocationManager = getLocationManager()
    let notificationManager = NotificationManager()
    
    var body: some Scene {
        WindowGroup {
            MainView(hkManager: $manager,
                     dataModel: dataModel,
                     todaysBeverages: todaysBeverages)
                .onAppear{
                    updateUI(dataModel: dataModel, hkManager: manager)
                    dataModel.setTodaysBeverages(todaysBeverages: todaysBeverages)
                }.environmentObject(sheetManager)
        }
    }
}

//func resetUserDefaults()->UserDefaults{
//    let userDefaults = UserDefaults.standard
//
//    userDefaults.removeObject(forKey: "timestamps")
//    userDefaults.removeObject(forKey: "beverages")
//    return userDefaults
//}

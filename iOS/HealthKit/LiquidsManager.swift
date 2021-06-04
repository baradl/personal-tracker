//
//  LiquidStatistics.swift
//  personal_tracker
//
//  Created by Bastian Radloff on 08.03.21.
//

import Foundation
import HealthKit


class LiquidsManager {
    let healthStore: HKHealthStore
    let waterType: HKQuantityType
    let caffeineType: HKQuantityType
    let ml: HKUnit
    let mg: HKUnit
    
    @Published var dataToday: Dictionary<String, Int> = ["water": 0, "caffeine": 0]
    @Published var dataLastDays: Dictionary<String, Array<Int>> = ["water": [], "caffeine": []]
    let todaysBeverages: UserDefaults = UserDefaults.standard
    
    init(healthStore: HKHealthStore) {
        self.healthStore = healthStore
        
        guard let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater) else {
            fatalError("*** Unable to create a water type ***")
        }
        self.waterType = waterType
        
        guard let caffeineType = HKObjectType.quantityType(forIdentifier: .dietaryCaffeine) else {
            fatalError("*** Unable to create a caffeine type ***")
        }
        self.caffeineType = caffeineType
        
        self.ml = HKUnit(from: "ml")
        self.mg = HKUnit(from: "mg")
        
        if !self.todaysBeverages.bool(forKey: "todaysBeverages"){
            let beverages: Array<Dictionary<String, String>> = []
            let todaysDates: Array<Date> = []
            self.todaysBeverages.setValue(beverages, forKey: "beverages")
            self.todaysBeverages.setValue(todaysDates, forKey: "dates")
        }
    }
    
    func getTodaysData(){
        if self.healthStore.authorizationStatus(for: self.waterType).rawValue == 2{
            self.getTodaysAmount(quantityType: self.waterType, unit: self.ml, key: "water")
            self.getLastDaysAmount(quantityType: self.waterType, unit: self.ml, key: "water")
        }
        if self.healthStore.authorizationStatus(for: self.caffeineType).rawValue == 2 {
            self.getTodaysAmount(quantityType: self.caffeineType, unit: self.mg, key: "caffeine")
            self.getLastDaysAmount(quantityType: self.caffeineType, unit: self.mg, key: "caffeine")
        }
    }
    
    
    func getTodaysAmount(quantityType: HKQuantityType, unit: HKUnit, key: String) {
        let calendar = Calendar.current
        
        var interval = DateComponents()
        interval.day = 1
        
        let anchorDate = self.getDefaultAnchorDate(calendar: calendar)
 
        let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                quantitySamplePredicate: nil,
                                                options: .cumulativeSum,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        query.initialResultsHandler = {
            query, results, error in
            
            guard let statsCollection = results else {
                // Perform proper error handling here
                fatalError("*** An error occurred while calculating the statistics: \(error!.localizedDescription) ***")
            }
            
            let endDate = Date()
            
            let startDate = self.getTodaysStart(calendar: calendar)
            statsCollection.enumerateStatistics(from: startDate, to: endDate) {statistics, stop in
                if let quantity = statistics.sumQuantity() {
                    self.dataToday[key] = Int(quantity.doubleValue(for: unit))
                }
            }
        }
        
        self.healthStore.execute(query)
    }
    
    func getLastDaysAmount(quantityType: HKQuantityType, unit: HKUnit, key: String) {
        let calendar = Calendar.current
        
        var interval = DateComponents()
        interval.day = 1
        
        let anchorDate = self.getDefaultAnchorDate(calendar: calendar)
 
        let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                quantitySamplePredicate: nil,
                                                options: .cumulativeSum,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        query.initialResultsHandler = {
            query, results, error in
            
            guard let statsCollection = results else {
                // Perform proper error handling here
                fatalError("*** An error occurred while calculating the statistics: \(error!.localizedDescription) ***")
            }
                        
            let dates = self.getLastDaysDates(calendar: calendar)
            let quantities = statsCollection.statistics()
            var dataLastDays: Array<Int> = []
            var previousDate = dates.start
            for quantity in quantities {
                if quantity.startDate > dates.start{
                    let daysInBetween = previousDate.distance(to: quantity.startDate) / 86400
                    for _ in 0..<Int(daysInBetween-1){
                        dataLastDays.append(0)
                    }
                    dataLastDays.append(Int(quantity.sumQuantity()!.doubleValue(for: unit)))
                }
                previousDate = quantity.startDate
            }
//            print("Data Last Days: \(dataLastDays)")
            self.dataLastDays[key] = dataLastDays
        }
        
        self.healthStore.execute(query)
    }
    
    
    func deleteBeverage() {}
    
    func saveBeverage(beverage: Beverage, portionsize: Int, time: Date) {
        let water = Int(Float(portionsize) * beverage.water)
        let caffeine = Int(Float(portionsize) * beverage.caffein)
        
        let metadata: Dictionary = ["uuid": UUID().uuidString, "beverage": beverage.name]
        
        let waterObject = HKQuantitySample(type: self.waterType,
                                           quantity: HKQuantity(unit: self.ml,
                                                                doubleValue: Double(water)),
                                            start: time,
                                            end: time,
                                            metadata: metadata)
        let caffeineObject = HKQuantitySample(type: self.caffeineType,
                                              quantity: HKQuantity(unit: self.mg,
                                                                   doubleValue: Double(caffeine)),
                                              start: time,
                                              end: time,
                                              metadata: metadata)
        
        self.healthStore.save(waterObject) {succes, error in
            if succes {
                print("*** Succesfully saved \(water)ml at \(time.description) ***")}
            else {
                print("*** Failed saving \(water)ml at \(time.description) ***")
            }
        }
        self.healthStore.save(caffeineObject){succes, error in
            if succes {
                print("*** Succesfully saved \(caffeine)mg at \(time.description) ***")}
            else {
                print("*** Failed saving \(caffeine)mg at \(time.description) ***")
            }
        }
        
        self.updateTodaysBeverages(beverage: beverage, time: time)
    }
    
    func updateTodaysBeverages(beverage: Beverage?, time: Date?){
        var todaysBeverages = self.todaysBeverages.object(forKey: "beverages") as! Array<Dictionary<String, String>>
        var todaysDates = self.todaysBeverages.object(forKey: "dates") as! Array<Date>
        
        if beverage == nil {
            if todaysBeverages.count != 0 {
                let calendar = Calendar.current
                
                let lastDay = calendar.dateComponents(Set([.day]), from: todaysDates[-1])
                let nowDay = calendar.dateComponents(Set([.day]), from: Date())
                
                if lastDay != nowDay {
                    todaysBeverages = []
                    todaysDates = []
                }
            }
        }else {
            let selectedBeverage: Beverage = beverage!
            let selectedTime: Date = time!
            
            todaysBeverages.append(["name": selectedBeverage.name, "logopath": selectedBeverage.logopath])
            todaysDates.append(selectedTime)
        }
        
        print("Beverages before Update: \(todaysBeverages)")
        
        self.todaysBeverages.setValue(todaysBeverages, forKey: "beverages")
        self.todaysBeverages.setValue(todaysDates, forKey: "dates")
        
        let test = self.todaysBeverages.object(forKey: "beverages") as! Array<Dictionary<String, String>>
        
        print("Beverages after Update: \(test)")
    }
    
    func getDefaultAnchorDate(calendar: Calendar) -> Date {
        var anchorDateComponents = DateComponents()
        anchorDateComponents.year = 2020
        anchorDateComponents.month = 1
        anchorDateComponents.day = 1
        anchorDateComponents.hour = 0
        anchorDateComponents.minute = 0
        anchorDateComponents.second = 0
        
        guard let anchorDate = calendar.date(from: anchorDateComponents) else {
            fatalError("*** unable to create a valid date from the given components ***")
        }
        
        return anchorDate
    }
    
    func getTodaysStart(calendar: Calendar) -> Date {
        let now = Date()
        
        var nowComponents = calendar.dateComponents(Set([.year, .month, .day, .hour, .minute, .second]),
                                                    from: now)
        nowComponents.hour = 0
        nowComponents.minute = 0
        nowComponents.second = 0
        guard let startDate = calendar.date(from: nowComponents) else {
            fatalError("*** Unable to calculate the start date ***")
        }
        return startDate
    }
    
    func getLastDaysDates(calendar: Calendar) -> (start: Date, end: Date) {
        let now = Date()
        
        var nowComponents = calendar.dateComponents(Set([.year, .month, .day, .hour, .minute, .second]),
                                                    from: now)
        nowComponents.hour = 0
        nowComponents.minute = 0
        nowComponents.second = 0
        nowComponents.day = nowComponents.day! - 7
        guard let startDate = calendar.date(from: nowComponents) else {
            fatalError("*** Unable to calculate the start date ***")
        }
        
        nowComponents.day = nowComponents.day! + 7
        
        guard let endDate = calendar.date(from: nowComponents) else {
            fatalError("*** Unable to calculate the start date ***")
        }
        
        return (startDate, endDate)
    }
    
}


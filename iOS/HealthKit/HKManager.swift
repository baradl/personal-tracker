//
//  DashboardManager.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 16.03.21.
//

import HealthKit
import CoreLocation

class HKManager {
    let healthStore: HKHealthStore?
    
    let waterType = HKObjectType.quantityType(forIdentifier: .dietaryWater)!
    let caffeineType = HKObjectType.quantityType(forIdentifier: .dietaryCaffeine)!
    let weightType = HKObjectType.quantityType(forIdentifier: .bodyMass)!
    let basalEnergyType = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
    let activeEnergyType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
    let stepsType = HKObjectType.quantityType(forIdentifier: .stepCount)!
    let standTimeType = HKObjectType.quantityType(forIdentifier: .appleStandTime)!
    let exerciseTimeType = HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!
    let consumedEnergyType = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)!
    
    let shareTypes: Set<HKSampleType>
    let readTypes: Set<HKObjectType>
    
    let types: Dictionary<String,HKObjectType>
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            self.healthStore = HKHealthStore()
            
            self.shareTypes = Set([self.waterType, self.caffeineType, self.weightType])
            
            self.readTypes = Set([self.waterType, self.caffeineType, self.weightType,
                                 self.stepsType, self.basalEnergyType, self.activeEnergyType,
                                 self.standTimeType, self.exerciseTimeType, self.consumedEnergyType,
                                 HKObjectType.workoutType(),
                                 HKObjectType.activitySummaryType(),
                                 HKSeriesType.workoutRoute()])
            
            self.healthStore!.requestAuthorization(toShare: self.shareTypes,
                                                   read: self.readTypes,
                                                   completion: {(success, error) in
                if success{
                    print("*** Authorization of HealthKit succesful ***")
                } else {
                    print("*** Error during requesting Authorization ***")
                }
            })
        } else {
            fatalError("Health Data not available. Are you on an iPad?")
        }
        
        self.types = ["water": self.waterType,
                      "caffeine": self.caffeineType,
                      "basalEnergy": self.basalEnergyType,
                      "weight": self.weightType,
                      "activeEnergy": activeEnergyType,
                      "steps": self.stepsType,
                      "standTime": self.standTimeType,
                      "exerciseTime": self.exerciseTimeType,
                      "consumedEnergy": self.consumedEnergyType]
    }
    
    func getRequestStatus(completion: @escaping (HKAuthorizationRequestStatus?) -> Void) {
        self.healthStore!.getRequestStatusForAuthorization(toShare: self.shareTypes,
                                                           read: self.readTypes,
                                                           completion: {(requestStatus, error) in
            completion(requestStatus)
        })
    }
    
    func getWorkouts(completion: @escaping ([HKWorkout]?) -> Void) {
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
                                              ascending: true)
        
        let query = HKSampleQuery(sampleType: .workoutType(),
                                  predicate: nil,
                                  limit: 0,
                                  sortDescriptors: [sortDescriptor]) {(query, samples, error) in
            
            let workouts = samples as! [HKWorkout]
            completion(workouts)
        }
        
        self.healthStore!.execute(query)
    }
    
    func getWorkoutRoute(workout: HKWorkout, completion: @escaping ([HKSample]?) -> Void) {
        let runningObjectQuery = HKQuery.predicateForObjects(from: workout)

        let routeQuery = HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: runningObjectQuery, anchor: nil, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, anchor, error) in
            
            guard error == nil else {
                fatalError("An error occurred: \(error!.localizedDescription)")
            }
            
            completion(samples)
        }
        self.healthStore!.execute(routeQuery)
    }
    
    func queryWorkoutRoute(route: HKWorkoutRoute, completion: @escaping ([CLLocation]?) -> Void) {
        let query = HKWorkoutRouteQuery(route: route) { (query, locationsOrNil, done, errorOrNil) in
            
            // This block may be called multiple times.
            
            if let error = errorOrNil {
                fatalError("An unhandled Error occurred: \(error.localizedDescription)")
            }
            
            guard let locations = locationsOrNil else {
                fatalError("*** Invalid State: This can only fail if there was an error. ***")
            }
            
            completion(locations)
        }
        self.healthStore!.execute(query)
    }

    
    func getStandingHours(completion: @escaping (HKStatisticsCollection?)->Void) {
        let calendar = Calendar.current
        
        var interval = DateComponents()
        interval.hour = 1
        
        let anchorDate = getDefaultAnchorDate(calendar: calendar)
        let (startDate, endDate) = getTodaysBounds()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: endDate,
                                                    options: .strictStartDate)
        
        let query = HKStatisticsCollectionQuery(quantityType: self.standTimeType,
                                                quantitySamplePredicate: predicate,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        query.initialResultsHandler = {
            query, results, error in
            completion(results)
        }
        
        query.statisticsUpdateHandler = {(query, statistics, statisticsCollection, error) in
            print("Statistics Update Handler fired.")
            completion(statisticsCollection)
        }
        
        self.healthStore!.execute(query)
    }
    
    func getWeights(completion: @escaping ([HKQuantitySample]?)->Void) {
        let endDate = Date()
        let startDate = Date.distantPast
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate,
                                              ascending: true)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: endDate,
                                                    options: .strictStartDate)
        
        let query = HKSampleQuery(sampleType: self.weightType,
                                  predicate: predicate,
                                  limit: 0,
                                  sortDescriptors: [sortDescriptor]) {(query, samples, error) in
                                    
            let bodyWeights = samples as! [HKQuantitySample]
            completion(bodyWeights)
        }
        
        self.healthStore!.execute(query)
    }
    
    func getActivitySummary(timeframe: String, completion: @escaping ([HKActivitySummary]?) -> Void) {
        var startDate: Date
        switch timeframe {
        case "today":
            startDate = getTodaysBounds().start
        case "days":
            startDate = getLastDaysStart(date: Date())
        case "weeks":
            startDate = getLastSixWeeksStart(date: Date())
        case "months":
            startDate = getLastSixMonthsStart(date: Date())
        case "all":
            startDate = get2020Start()
        default:
            fatalError("Timeframe -\(timeframe)- not acceptable! Choose days, weeks, months or all")
        }
        
        let calendar = Calendar.current
        var startComponents = calendar.dateComponents([.year, .month, .day],
                                                              from: startDate)
        startComponents.calendar = calendar
        var endComponents = calendar.dateComponents([.year, .month, .day],
                                                    from: getTodaysBounds().end)
        endComponents.calendar = calendar
        
        let predicate = HKQuery.predicate(forActivitySummariesBetweenStart: startComponents,
                                          end: endComponents)
        
        let query = HKActivitySummaryQuery(predicate: predicate, resultsHandler: {(query, result, error) in
            let activitySummaries = result!
            completion(activitySummaries)
        })
        
        query.updateHandler = {(query, result, error) in
            print("Activity Summary Update Handler fired.")
            let activitySummaries = result!
            completion(activitySummaries)
        }
        
        self.healthStore!.execute(query)
    }
    
    func getDailySumToday(quantityType: HKQuantityType, completion: @escaping (HKStatisticsCollection?)-> Void) {
        let calendar = Calendar.current
        
        var interval = DateComponents()
        interval.day = 1
        
        let anchorDate = getDefaultAnchorDate(calendar: calendar)
        let (startDate, endDate) = getTodaysBounds()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: endDate,
                                                    options: .strictStartDate)
        
        let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                quantitySamplePredicate: predicate,
                                                options: .cumulativeSum,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        query.initialResultsHandler = { (query, statisticsCollection, error) in
            completion(statisticsCollection)
        }
        
        query.statisticsUpdateHandler = {(query, statistics, statisticsCollection, error) in
            print("Statistics Update Handler fired.")
            completion(statisticsCollection)
        }
        
        self.healthStore!.execute(query)
    }
    
    func getDailySumValueHistory(quantityType: HKQuantityType, timeframe: String, completion: @escaping (HKStatisticsCollection?)->Void) {
        var startDate: Date
        switch timeframe {
        case "days":
            startDate = getLastDaysStart(date: Date())
        case "weeks":
            startDate = getLastSixWeeksStart(date: Date())
        case "months":
            startDate = getLastSixMonthsStart(date: Date())
        case "all":
            startDate = get2020Start()
        default:
            fatalError("Timeframe -\(timeframe)- not acceptable! Choose days, weeks, months or all")
        }
        
        let calendar = Calendar.current
        
        var interval = DateComponents()
        interval.day = 1
        
        let anchorDate = getDefaultAnchorDate(calendar: calendar)
        let endDate = getTodaysBounds().end
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate,
                                                    end: endDate,
                                                    options: .strictStartDate)
 
        let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                quantitySamplePredicate: predicate,
                                                options: .cumulativeSum,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        query.initialResultsHandler = { (query, statisticsCollection, error) in
            if let error = error {
                print("Error for initial Result: \(error.localizedDescription)")
            }
            completion(statisticsCollection)
        }
        
        query.statisticsUpdateHandler = {(query, statistics, statisticsCollection, error) in
            print("Statistics Update Handler fired.")
            if let error = error {
                print("Error on Update: \(error.localizedDescription)")
            }
            completion(statisticsCollection)
        }
        
        self.healthStore!.execute(query)
    }
    
    func deleteBeverage(selectedBeverage: SelectedBeverage){
        let waterPredicate = HKQuery.predicateForObject(with: selectedBeverage.waterObjectUUID)
        let caffeinePredicate = HKQuery.predicateForObject(with: selectedBeverage.caffeineObjectUUID)
        
        self.healthStore?.deleteObjects(of: self.waterType, predicate: waterPredicate, withCompletion: {success, objectCount, error in
            if success {
                print("Succesfully deleted \(objectCount) object related to Water")
            } else {
                print("Failed deleting water object: \(String(describing: error?.localizedDescription))")
            }
        })
        
        self.healthStore?.deleteObjects(of: self.caffeineType, predicate: caffeinePredicate, withCompletion: {success, objectCount, error in
            if success {
                print("Succesfully deleted \(objectCount) object related to Caffeine")
            } else {
                print("Failed deleting caffeine object: \(String(describing: error?.localizedDescription))")
            }
        })
    }
    
    func saveBeverage(selectedBeverage: SelectedBeverage){
        let waterAmount = HKQuantity(unit: HKUnit(from: "ml"),
                                     doubleValue: Double(selectedBeverage.beverage.water * Float(selectedBeverage.portionsize)))
        let caffeineAmount = HKQuantity(unit: HKUnit(from: "mg"),
                                        doubleValue: Double(selectedBeverage.beverage.caffeine * Float(selectedBeverage.portionsize)))
        
        let waterObject = HKQuantitySample(type: self.waterType,
                                           quantity: waterAmount,
                                           start: selectedBeverage.timestamp,
                                           end: selectedBeverage.timestamp)
        let caffeineObject = HKQuantitySample(type: self.caffeineType,
                                              quantity: caffeineAmount,
                                              start: selectedBeverage.timestamp,
                                              end: selectedBeverage.timestamp)
        
        selectedBeverage.waterObjectUUID = waterObject.uuid
        selectedBeverage.caffeineObjectUUID = caffeineObject.uuid
        
        self.healthStore!.save(waterObject, withCompletion: {(success, error) in
            if success {
                print("Succesfully saved \(Int(waterAmount.doubleValue(for: HKUnit(from: "ml"))))ml for \(selectedBeverage.beverage.name)")
            } else {
                print("Failed saving \(Int(waterAmount.doubleValue(for: HKUnit(from: "ml"))))ml for \(selectedBeverage.beverage.name)")
            }
        })
        self.healthStore!.save(caffeineObject, withCompletion: {(success, error) in
            if success {
                print("Succesfully saved \(Int(caffeineAmount.doubleValue(for: HKUnit(from: "mg"))))mg for \(selectedBeverage.beverage.name)")
            } else {
                print("Failed saving \(Int(caffeineAmount.doubleValue(for: HKUnit(from: "mg"))))mg for \(selectedBeverage.beverage.name)")
            }
        })
    }
    
    func saveWeight(weight: Weight){
        let weightAmount = HKQuantity(unit: HKUnit(from: "kg"),
                                      doubleValue: weight.weight)
        let weightObject = HKQuantitySample(type: self.weightType,
                                            quantity: weightAmount,
                                            start: weight.timestamp,
                                            end: weight.timestamp)
        
        
        self.healthStore!.save(weightObject, withCompletion: {(success, error) in
            if success {
                print("Successfully saved Weight")
            } else {
                print("Failed saving Weight")
            }
        })
    }
    
    func deleteWeight(weight: Weight){
        let weightPredicate = HKQuery.predicateForObject(with: weight.id)
        
        self.healthStore?.deleteObjects(of: self.weightType, predicate: weightPredicate, withCompletion: {success, objectCount, error in
            if success {
                print("Succesfully deleted \(objectCount) object related to Bodyweight")
            } else {
                print("Failed deleting weight object: \(String(describing: error?.localizedDescription))")
            }
        })
    }
}


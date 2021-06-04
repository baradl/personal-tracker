//
//  UIUpdate.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 16.03.21.
//

import HealthKit

func updateUIDailySumToday(_ statisticsCollection: HKStatisticsCollection, dataModel: DataModel, key: String) {
    let (startDate, endDate) = getTodaysBounds()

    statisticsCollection.enumerateStatistics(from: startDate, to: endDate) {(statistics, stop) in
        let value = statistics.sumQuantity()?.doubleValue(for: dataModel.unitMapping[key]!)
        dataModel.updateDailySumToday(key: key, value: value!)
    }
}

func updateUIDailySumHistory(_ statisticsCollection: HKStatisticsCollection, dataModel: DataModel, key: String, timeframe: String){
    
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
    
    let quantities = statisticsCollection.statistics()
    var historyData: Array<Double> = []
    var previousDate = startDate
    for quantity in quantities {
        if quantity.startDate > startDate{
            let daysInBetween = Calendar.current.numberOfDaysBetween(previousDate, and: quantity.startDate) - 1
            for _ in 0..<Int(daysInBetween-1){
                historyData.append(0)
            }
            historyData.append(quantity.sumQuantity()!.doubleValue(for: dataModel.unitMapping[key]!))
        }
        previousDate = quantity.startDate
    }
    
    if timeframe == "all"{
        historyData.insert(0, at: 0)
    }

    let daysInBetween = Calendar.current.numberOfDaysBetween(previousDate, and: Date())
    
    for _ in 1 ..< Int(daysInBetween){
        historyData.append(0)
    }
    
    let datapoints = toDatapoints(data: historyData, startDate: startDate)
    if datapoints.count == 1 {
        print("ALERT for \(key) - DATAPOINTS: \(datapoints.count)")
    }
    switch timeframe {
    case "days":
        dataModel.updateDailySumDays(key: key,
                                     values: getLastDaysValues(datapoints: datapoints))
    case "weeks":
        dataModel.updateDailySumDays(key: key,
                                     values: getLastDaysValues(datapoints: datapoints))
        dataModel.updateDailySumWeeks(key: key,
                                     values: getWeeklyAverages(datapoints: datapoints))
    case "months":
        dataModel.updateDailySumDays(key: key,
                                     values: getLastDaysValues(datapoints: datapoints))
        dataModel.updateDailySumWeeks(key: key,
                                     values: getWeeklyAverages(datapoints: datapoints))
        dataModel.updateDailySumMonths(key: key,
                                     values: getMonthlyAverages(datapoints: datapoints))
    case "all":
        let overallAverage = getOverallAverage(datapoints: datapoints)
        
        dataModel.updateDailySumHistoryMetrics(key: key,
                                               maxValue: historyData.max()!,
                                               avgValue: overallAverage)
        dataModel.updateDailySumDays(key: key,
                                     values: getLastDaysValues(datapoints: datapoints))
        dataModel.updateDailySumWeeks(key: key,
                                     values: getWeeklyAverages(datapoints: datapoints))
        dataModel.updateDailySumMonths(key: key,
                                     values: getMonthlyAverages(datapoints: datapoints))
    default:
        fatalError("Timeframe -\(timeframe)- not acceptable! Choose days, weeks, months or all")
    }
    
    print("+++ Updated DailySumValue \(key) for timeframe \(timeframe) +++")
}

func updateActivitySummary(hkManager: HKManager, dataModel: DataModel, timeframe: String) {
    hkManager.getRequestStatus(completion: {requestStatus in
        if let requestStatus = requestStatus {
            if requestStatus.rawValue == 2 {
                hkManager.getActivitySummary(timeframe: timeframe, completion: {activitySummaries in
                    if let activitySummaries = activitySummaries{
                            DispatchQueue.main.async {
                                if activitySummaries.count == 1 {
                                    dataModel.activitySummary.summaries[dataModel.activitySummary.summaries.count - 1] = activitySummaries.first!
                                } else {
                                    dataModel.activitySummary.summaries = activitySummaries
                                }
                            
                            }
                        }
                    })
                }
            }
    })
}


func updateUITodaysStandingHours(_ statisticsCollection: HKStatisticsCollection, dataModel: DataModel){
    let calendar = Calendar.current
    
    let quantities = statisticsCollection.statistics()
    var standingHours: Array<Int> = Array(repeating: -1, count: 24)
    for quantity in quantities{
        let startHour = calendar.dateComponents([.hour], from: quantity.endDate).hour! - 1
        if quantity.sumQuantity()!.doubleValue(for: dataModel.unitMapping["standTime"]!) >= 1.0 {
            standingHours[startHour] = 1
        }
    }
    let hourNow = calendar.dateComponents([.hour], from: Date()).hour!
    
    for (hour, status) in standingHours.enumerated(){
        if hour <= hourNow && status == -1 {
            standingHours[hour] = 0
        }
    }
    DispatchQueue.main.async {
        dataModel.activitySummary.standingHours = standingHours
    }
}

func updateUIWeights(_ bodyWeights: [HKQuantitySample], dataModel: DataModel){
    var weights: Array<Weight> = []
    for weightRead in bodyWeights {
        let weight = Weight(weight: weightRead.quantity.doubleValue(for: dataModel.kg),
                        timestamp: weightRead.startDate)
        weight.id = weightRead.uuid
        let recordedDates = weights.map({$0.timestamp})
        if !recordedDates.contains(weight.timestamp) {
            weights.append(weight)
        }
    }
    if weights.count != 0 {dataModel.updateWeights(values: weights)}
}

func updateUIWorkouts(_ hkWorkouts: [HKWorkout], dataModel: DataModel){
    var workouts: Array<HKWorkout> = []
    
    for hkWorkout in hkWorkouts{
        if hkWorkout.workoutActivityType == .running ||
            hkWorkout.workoutActivityType == .functionalStrengthTraining ||
                hkWorkout.workoutActivityType == .mixedCardio{
            workouts.append(hkWorkout)
        }
        else if hkWorkout.workoutActivityType == .walking && hkWorkout.duration >= 30*60{
            workouts.append(hkWorkout)
        }
        else if hkWorkout.workoutActivityType == .cycling && hkWorkout.totalDistance!.doubleValue(for: HKUnit(from: "km")) >= 5{
            workouts.append(hkWorkout)
        }
    }
    dataModel.updateWorkoutData(workouts: workouts)
}


func updateDailySumHistory(hkManager: HKManager, dataModel: DataModel, key: String, timeframe: String){
    hkManager.getDailySumValueHistory(quantityType: hkManager.types[key] as! HKQuantityType,
                                      timeframe: timeframe,
                                      completion: { statisticsCollection in
                                    if let statisticsCollection = statisticsCollection {
                                        updateUIDailySumHistory(statisticsCollection,
                                                            dataModel: dataModel,
                                                            key: key,
                                                            timeframe: timeframe)
                                    }
                                  })
}


func updateWeightTrackerData(hkManager: HKManager, dataModel: DataModel) {
    hkManager.getRequestStatus(completion: {requestStatus in
        if let requestStatus = requestStatus {
            if requestStatus.rawValue == 2 {
                hkManager.getWeights(completion: {bodyWeights in
                    if let bodyWeights = bodyWeights {
                        updateUIWeights(bodyWeights, dataModel: dataModel)
                    }
                })
            }
        }
    })
}


func updateWorkouts(dataModel: DataModel, hkManager: HKManager){
    hkManager.getRequestStatus(completion: {requestStatus in
        if let requestStatus = requestStatus {
            if requestStatus.rawValue == 2 {
                hkManager.getWorkouts(completion: {hkWorkouts in
                    if let hkWorkouts = hkWorkouts {
                        updateUIWorkouts(hkWorkouts, dataModel: dataModel)
                    }
                })
            }
        }
    })
}



func updateUI(dataModel: DataModel, hkManager: HKManager) {
    hkManager.getRequestStatus(completion: {requestStatus in
        if let requestStatus = requestStatus {
            if requestStatus.rawValue == 2 {
                for key in hkManager.types.keys{
                    if key == "standTime" {
                        hkManager.getStandingHours(completion: {statisticsCollection in
                            if let statisticsCollection = statisticsCollection {
                                updateUITodaysStandingHours(statisticsCollection, dataModel: dataModel)
                            }
                        })
                    } else if key != "weight" {
                        updateDailySumHistory(hkManager: hkManager, dataModel: dataModel, key: key, timeframe: "all")
                    }
                }
                
                updateWorkouts(dataModel: dataModel, hkManager: hkManager)
            }
        }
    })
}



//hkManager.getDailySumValueLastSixMonths(quantityType: hkManager.types[key] as! HKQuantityType,
//                            completion: { statisticsCollection in
//                                if let statisticsCollection = statisticsCollection {
//                                    updateUILastSixMonthsData(statisticsCollection, dataModel: dataModel, key: key)
//                                }
//                              })

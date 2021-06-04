//
//  Averages.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 24.03.21.
//

import Foundation


func getAverages(data: Array<Double>) -> (daily: Array<(String, Double)>,
                                          weekly: Array<(String, Double)>,
                                          monthly: Array<(String, Double)>){
    
    let startDate : Date = getLastSixMonthsStart(date: Date())
    let datapoints = toDatapoints(data: data, startDate: startDate)
    
    let dailyValues = getLastDaysValues(datapoints: datapoints)
    
    let weeklyValues = getWeeklyAverages(datapoints: datapoints)
    let monthlyValues = getMonthlyAverages(datapoints: datapoints)

    return (dailyValues, weeklyValues, monthlyValues)
}


func getOverallAverage(datapoints: Array<Datapoint>) -> Double {
    let startToday = getTodaysBounds().start
    let numberNonZero = datapoints.filter{datapoint in
        return datapoint.value != 0.0 && datapoint.timestamp < startToday
    }.count
    
    let sum = datapoints.reduce(0.0){(result, datapoint) in
        return datapoint.timestamp < startToday ? result + datapoint.value : result
    }
    
    return sum/Double(numberNonZero)
}

func getLastDaysValues(datapoints: Array<Datapoint>) -> Array<(String, Double)>{
    let dateFormatter = getDateFormatter(format: "EEEE")
    
    let dailyValues = datapoints.reversed().filter{datapoint in
        return datapoint.timestamp > getLastDaysStart(date: Date())
    }.map{datapoint in
        return (String(dateFormatter.string(from: datapoint.timestamp).prefix(3)),
                datapoint.value)
    }
    
//    print("Last Days Values: \(dailyValues.count)")
    return dailyValues.reversed()
}

func getWeeklyAverages(datapoints: Array<Datapoint>) -> Array<(String, Double)> {
    let dateFormatter = getDateFormatter(format: "dd.MM.")
    
    let startDate = getLastSixWeeksStart(date: Date())
    let weeklyBound = getWeeklyBounds(start: startDate)
    var averages: Array<(String, Double)> = []
    
    for bound in weeklyBound {
        let weekValues = datapoints.filter{datapoint in
            return datapoint.value != 0.0 && datapoint.timestamp >= bound.0 && datapoint.timestamp < bound.1
        }
        let weekString = "\(dateFormatter.string(from: bound.0))\n\(dateFormatter.string(from: bound.1))"
        
        if weekValues.isEmpty{
            averages.append((weekString, 0.0))
        } else {
            let weekSum = weekValues.reduce(0.0){(result, element) in
                return result + element.value
            }
            averages.append((weekString, weekSum/Double(weekValues.count)))
        }
    }
    return averages
}

func getMonthlyAverages(datapoints: Array<Datapoint>) -> Array<(String, Double)> {
    var startDate = getLastSixMonthsStart(date: Date())
    var averages: Array<(String, Double)> = []
    
    var endDate = getMonthsEnd(date: startDate)
    let dateFormatter = getDateFormatter(format: "MMMM")
    
    while startDate <= Date() {
        let monthValues = datapoints.filter{datapoint in
            return datapoint.value != 0.0 && datapoint.timestamp >= startDate && datapoint.timestamp < endDate
        }
    
        let monthString = String(dateFormatter.string(from: startDate).prefix(3))
        if monthValues.isEmpty {
            averages.append((monthString, 0.0))
        } else {
            let monthSum = monthValues.reduce(0.0){(result, element) in
                return result + element.value
            }
            averages.append((monthString,  monthSum/Double(monthValues.count)))
        }
        
        startDate = endDate
        endDate = getMonthsEnd(date: startDate)
    }
    
    return averages
}

//
//  Sums.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 26.03.21.
//

import Foundation
import HealthKit

//func getActiveLastDays(workouts: Array<HKWorkout>) -> Array<(String, Bool)> {
//    let dateFormatter = getDateFormatter(format: "E")
//    let lastDaysStart = getLastDaysStart(date: Date())
//    let lastSeve
//    let workoutsLastDays = workouts.filter({ workout in
//        return workout.startDate > lastDaysStart
//    })
//
//    return [("-", false)]
//}

func getNumberWeeklyWorkouts(workouts: Array <HKWorkout>) -> Array<(String, Double)> {
    let dateFormatter = getDateFormatter(format: "dd.MM.")
    let weeklyBound = getWeeklyBounds(start: getLastSixWeeksStart(date: Date()))
    
    var workoutsPerWeek: Array<(String, Double)> = []
    
    for bound in weeklyBound {
        let weekWorkouts = workouts.filter{workout in
            return workout.startDate >= bound.0 && workout.startDate < bound.1
        }
        let weekString = "\(dateFormatter.string(from: bound.0))\n\(dateFormatter.string(from: bound.1))"
        
        workoutsPerWeek.append((weekString, Double(weekWorkouts.count)))
        
    }
    return workoutsPerWeek
}

func getNumberMonthlyWorkouts(workoutsPerMonth: Array<(String, Array<HKWorkout>)>) -> Array<(String, Double)> {
    let lastSevenMonth = workoutsPerMonth[workoutsPerMonth.count-7 ..< workoutsPerMonth.count]
    
    let numberWorkoutsPerMonth = lastSevenMonth.map{(month, workouts) in
        return (String(month.prefix(3)), Double(workouts.count))
    }
    return numberWorkoutsPerMonth
}

func getWorkoutsPerMonth(workouts: Array<HKWorkout>) -> Array<(String, Array<HKWorkout>)> {
    var startDate = getRecordingStart()
    
    var endDate = getMonthsEnd(date: startDate)
    let dateFormatterMonth = getDateFormatter(format: "MMMM")
    let dateFormatterYear = getDateFormatter(format: "yy")
    
    var workoutsPerMonth : Array<(String, Array<HKWorkout>)> = []
    
    while startDate <= Date() {
        let monthWorkouts = workouts.filter{workout in
            return workout.startDate >= startDate && workout.startDate < endDate
        }
        
        let monthString = String(dateFormatterMonth.string(from: startDate).prefix(3))
        let yearString = dateFormatterYear.string(from: startDate)
        
        workoutsPerMonth.append(("\(monthString)\(yearString)", monthWorkouts.reversed()))
        startDate = endDate
        endDate = getMonthsEnd(date: startDate)
    }
    
    return workoutsPerMonth
}

func getRunningDistances(workouts: Array<HKWorkout>) -> (thisMonth: Double,
                                                         weeks: Array<(String, Double)>,
                                                         months: Array<(String, Double)>) {
    let weekValues = getWeeklyDistances(workouts: workouts.filter{ workout in
        return workout.startDate >= getLastSixWeeksStart(date: Date()) && workout.workoutActivityType == .running
    })
    
    let monthValues = getMonthlyDistances(workouts: workouts.filter{ workout in
        return workout.startDate >= getLastSixMonthsStart(date: Date()) && workout.workoutActivityType == .running
    })
    
    return (monthValues.last!.1, weekValues, monthValues)
}

func getWalkingDistances(workouts: Array<HKWorkout>)  -> (thisMonth: Double,
                                                          weeks: Array<(String, Double)>,
                                                          months: Array<(String, Double)>) {
     let weekValues = getWeeklyDistances(workouts: workouts.filter{ workout in
         return workout.startDate >= getLastSixWeeksStart(date: Date()) && workout.workoutActivityType == .walking
     })
     
     let monthValues = getMonthlyDistances(workouts: workouts.filter{ workout in
         return workout.startDate >= getLastSixMonthsStart(date: Date()) && workout.workoutActivityType == .walking
     })
     
     return (monthValues.last!.1, weekValues, monthValues)
}

func getBikingDistances(workouts: Array<HKWorkout>)  -> (thisMonth: Double,
                                                         weeks: Array<(String, Double)>,
                                                         months: Array<(String, Double)>) {
    let weekValues = getWeeklyDistances(workouts: workouts.filter{ workout in
        return workout.startDate >= getLastSixWeeksStart(date: Date()) && workout.workoutActivityType == .cycling
    })
    
    let monthValues = getMonthlyDistances(workouts: workouts.filter{ workout in
        return workout.startDate >= getLastSixMonthsStart(date: Date()) && workout.workoutActivityType == .cycling
    })
    
    return (monthValues.last!.1, weekValues, monthValues)
}

func getWeeklyDistances(workouts: Array<HKWorkout>) -> Array<(String, Double)> {
    let dateFormatter = getDateFormatter(format: "dd.MM.")
    let weeklyBound = getWeeklyBounds(start: getLastSixWeeksStart(date: Date()))
    
    var sums: Array<(String, Double)> = []
    
    for bound in weeklyBound {
        let weekDistances = workouts.filter{workout in
            return workout.startDate >= bound.0 && workout.startDate < bound.1
        }
        let weekString = "\(dateFormatter.string(from: bound.0))\n\(dateFormatter.string(from: bound.1))"
        
        if weekDistances.isEmpty{
            sums.append((weekString, 0.0))
        } else {
            let weekSum = weekDistances.reduce(0.0){(distance, workout) in
                return distance + (workout.totalDistance?.doubleValue(for: HKUnit(from: "km")) ?? 0)
            }
            sums.append((weekString, weekSum))
        }
    }
    return sums
}

func getMonthlyDistances(workouts: Array<HKWorkout>) -> Array<(String, Double)> {
    var sums: Array<(String, Double)> = []
    
    var startDate = getLastSixMonthsStart(date: Date())
    var endDate = getMonthsEnd(date: startDate)
    let dateFormatter = getDateFormatter(format: "MMMM")
    
    while startDate <= Date() {
        let monthDistances = workouts.filter{workout in
            return workout.startDate >= startDate && workout.startDate < endDate
        }
    
        let monthString = String(dateFormatter.string(from: startDate).prefix(3))
        if monthDistances.isEmpty {
            sums.append((monthString, 0.0))
        } else {
            let monthSum = monthDistances.reduce(0.0){(distance, workout) in
                return distance + (workout.totalDistance?.doubleValue(for: HKUnit(from: "km")) ?? 0)
            }
            sums.append((monthString,  monthSum))
        }
        
        startDate = endDate
        endDate = getMonthsEnd(date: startDate)
    }
    
    return sums
}

//
//  WorkoutData.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 29.03.21.
//

import Foundation
import HealthKit

struct WorkoutData {
    var workoutsPerMonth: Array<(String, Array<HKWorkout>)> = []
    var numberWorkoutsPerWeek: Array<(String, Double)> = []
    var numberWorkoutsPerMonth: Array<(String, Double)> = []
    
    var runningDistanceThisMonth : Double = 0.0
    var runningDistanceWeeks : Array<(String, Double)> = []
    var runningDistanceMonths : Array<(String, Double)> = []
    
    var walkingDistanceThisMonth: Double = 0.0
    var walkingDistanceMonths : Array<(String, Double)> = []
    
    var bikingDistanceThisMonth: Double = 0.0
    var bikingDistanceMonths : Array<(String, Double)> = []
    
    func getWorkouts(index: Int) -> Array<HKWorkout> {
        let monthIndex = self.workoutsPerMonth.count - 1 - index
        if monthIndex >= 0 && monthIndex < self.workoutsPerMonth.count {
            return self.workoutsPerMonth[monthIndex].1.filter({workout in
                    return workout.workoutActivityType != .walking && workout.workoutActivityType != .cycling
                })
        } else {
            let workouts : Array<HKWorkout> = []
            return workouts
        }
    }
    
    func getMovementWorkouts(index: Int) -> Array<HKWorkout> {
        let monthIndex = self.workoutsPerMonth.count - 1 - index
        if monthIndex >= 0 && monthIndex < self.workoutsPerMonth.count {
            return self.workoutsPerMonth[monthIndex].1.filter({workout in
                return workout.workoutActivityType == .walking ||
                       workout.workoutActivityType == .cycling
                       
                })
        } else {
            let workouts : Array<HKWorkout> = []
            return workouts
        }
    }
    
    func getFlexibilityWorkouts(index: Int) -> Array<HKWorkout> {
        let monthIndex = self.workoutsPerMonth.count - 1 - index
        if monthIndex >= 0 && monthIndex < self.workoutsPerMonth.count {
            return self.workoutsPerMonth[monthIndex].1.filter({workout in
                return workout.workoutActivityType == .flexibility ||
                       workout.workoutActivityType == .yoga
                })
        } else {
            let workouts : Array<HKWorkout> = []
            return workouts
        }
    }
    
    func getAllFlexibilityWorkouts()-> Array<HKWorkout> {
        return self.workoutsPerMonth.map( {(month, workout) -> Array<HKWorkout> in
            return workout
        }).flatMap{$0}.filter({workout in
            return workout.workoutActivityType == .flexibility || workout.workoutActivityType == .yoga
        })
    }

    
    func getRunningDistance(index: Int) -> Double {
        let runningWorkouts = getRunningWorkouts(index: index)
        return runningWorkouts.reduce(0){(sum, workout) in
            return sum + workout.totalDistance!.doubleValue(for: HKUnit(from: "km"))
        }
    }
    
    func getRunningWorkouts(index: Int) -> Array<HKWorkout>{
        let monthIndex = self.workoutsPerMonth.count - 1 - index
        if monthIndex >= 0 && monthIndex < self.workoutsPerMonth.count {
            return self.workoutsPerMonth[monthIndex].1.filter{workout in
                return workout.workoutActivityType == .running}
        } else {
            let runs : Array<HKWorkout> = []
            return runs
        }
    }
    
    
    func getNumberWorkoutTypes(index: Int) -> (strength: Int, runs: Int, cardio: Int) {
        let monthIndex = self.workoutsPerMonth.count - 1 - index
        if monthIndex >= 0 && monthIndex < self.workoutsPerMonth.count {
            let workouts = self.workoutsPerMonth[monthIndex].1
            let strength = workouts.filter({workout in
                return workout.workoutActivityType == .functionalStrengthTraining
            }).count
            
            let runs = workouts.filter({workout in
                return workout.workoutActivityType == .running
            }).count
            
            let cardio = workouts.filter({workout in
                return workout.workoutActivityType == .mixedCardio
            }).count
            
            return (strength, runs, cardio)
        } else {
            return (0, 0, 0)
        }
    }
    
    func getPace(index: Int) -> String {
        if self.getRunningDistance(index: index) == 0.0 {
            return " - "
        } else {
            let workoutsMonth: Array<HKWorkout> = self.getRunningWorkouts(index: index)
            let timeMonth: Double = workoutsMonth.reduce(0.0, {(time, workout) in
                return time + workout.duration
            })
            let distanceMonth: Double = workoutsMonth.reduce(0){(sum, element) in
                return sum + element.totalDistance!.doubleValue(for: HKUnit(from: "km"))
            }
            
            let pace:Double = (timeMonth/60)/distanceMonth
            
            let paceString : String = timeDoubleToString(time: pace)
            return paceString
        }
    }
}

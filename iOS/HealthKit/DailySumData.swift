//
//  DailySumData.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 29.03.21.
//

import Foundation


struct DailySumData {
    var today: DataToday = DataToday()
    var days: DataHistory = DataHistory()
    var weeks: DataHistory = DataHistory()
    var months: DataHistory = DataHistory()
    var historyMetrics: DataHistoryMetrics = DataHistoryMetrics()
    
    let keys: Array<String> = ["water",
                               "caffeine",
                               "basalEnergy",
                               "activeEnergy",
                               "steps",
                               "exerciseTime",
                               "standTime",
                               "consumedEnergy"]

}


struct DataToday {
    var water: Double = 0.0
    var caffeine: Double = 0.0
    var basalEnergy: Double = 0.0
    var activeEnergy: Double = 0.0
    var steps: Double = 0.0
    var exerciseTime: Double = 0.0
    var standTime: Double = 0.0
    var consumedEnergy: Double = 0.0
    
    func description() -> String {
        return """
                water: \(self.water) \n
                caffeine: \(self.caffeine) \n
                basalEnergy: \(self.basalEnergy) \n
                activeEnergy: \(self.activeEnergy) \n
                steps: \(self.steps) \n
                consumedEnergy: \(self.consumedEnergy)
                """
    }
}

struct DataHistoryMetrics {
    var water: HistoryMetrics = HistoryMetrics()
    var caffeine: HistoryMetrics = HistoryMetrics()
    var basalEnergy: HistoryMetrics = HistoryMetrics()
    var activeEnergy: HistoryMetrics = HistoryMetrics()
    var steps: HistoryMetrics = HistoryMetrics()
    var exerciseTime: HistoryMetrics = HistoryMetrics()
    var standTime: HistoryMetrics = HistoryMetrics()
    var consumedEnergy: HistoryMetrics = HistoryMetrics()
}

struct HistoryMetrics{
    var max: Double = 0
    var avg: Double = 0
}

struct DataHistory {
    var water: Array<(String, Double)> = Array(repeating: ("-", 0.0), count: 7)
    var caffeine: Array<(String, Double)> = Array(repeating: ("-", 0.0), count: 7)
    var basalEnergy: Array<(String, Double)> = Array(repeating: ("-", 0.0), count: 7)
    var activeEnergy: Array<(String, Double)> = Array(repeating: ("-", 0.0), count: 7)
    var steps: Array<(String, Double)> = Array(repeating: ("-", 0.0), count: 7)
    var exerciseTime: Array<(String, Double)> = Array(repeating: ("-", 0.0), count: 7)
    var standTime: Array<(String, Double)> = Array(repeating: ("-", 0.0), count: 7)
    var consumedEnergy: Array<(String, Double)> = Array(repeating: ("-", 0.0), count: 7)
}

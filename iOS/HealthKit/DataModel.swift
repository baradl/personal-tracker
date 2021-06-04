//
//  DataModel.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 16.03.21.
//

import HealthKit

class DataModel : ObservableObject {
    @Published var dailySumData: DailySumData = DailySumData()
    
    @Published var activitySummary: ActivitySummary = ActivitySummary()
    
    @Published var workoutData: WorkoutData = WorkoutData()
    
    @Published var todaysBeverages: Array<SelectedBeverage> = []
    @Published var weights: Array<Weight> = []
    @Published var currentWeight: Weight?
    
    let unitMapping: Dictionary<String, HKUnit>
    let kcal = HKUnit(from: "kcal")
    let mg = HKUnit(from: "mg")
    let ml = HKUnit(from: "ml")
    let count = HKUnit(from: "count")
    let min = HKUnit(from: "min")
    let kg = HKUnit(from: "kg")
    let km = HKUnit(from: "km")
    
    init(){
        self.unitMapping = ["water": self.ml,
                           "caffeine": self.mg,
                           "weight": self.kg,
                           "steps": self.count,
                           "basalEnergy": self.kcal,
                           "activeEnergy": self.kcal,
                           "consumedEnergy": self.kcal,
                           "exerciseTime": self.min,
                           "standTime": self.min,
                           "runningDistance": self.km,
                           "numberWorkouts": self.count]
    }
    
    func updateDailySumHistoryMetrics(key:String, maxValue: Double, avgValue: Double) {
        DispatchQueue.main.async {
            switch key {
            case "water":
                self.dailySumData.historyMetrics.water.max = maxValue
                self.dailySumData.historyMetrics.water.avg = avgValue
            case "caffeine":
                self.dailySumData.historyMetrics.caffeine.max = maxValue
                self.dailySumData.historyMetrics.caffeine.avg = avgValue
            case "basalEnergy":
                self.dailySumData.historyMetrics.basalEnergy.max = maxValue
                self.dailySumData.historyMetrics.basalEnergy.avg = avgValue
            case "activeEnergy":
                self.dailySumData.historyMetrics.activeEnergy.max = maxValue
                self.dailySumData.historyMetrics.activeEnergy.avg = avgValue
            case "steps":
                self.dailySumData.historyMetrics.steps.max = maxValue
                self.dailySumData.historyMetrics.steps.avg = avgValue
            case "consumedEnergy":
                self.dailySumData.historyMetrics.consumedEnergy.max = maxValue
                self.dailySumData.historyMetrics.consumedEnergy.avg = avgValue
            case "standTime":
                self.dailySumData.historyMetrics.standTime.max = maxValue
                self.dailySumData.historyMetrics.standTime.avg = avgValue
            case "exerciseTime":
                self.dailySumData.historyMetrics.exerciseTime.max = maxValue
                self.dailySumData.historyMetrics.exerciseTime.avg = avgValue
            default: print("Key -\(key)- not associated with Daily Sum Data")
            }
        }
    }
    
    func updateDailySumToday(key:String, value:Double){
        DispatchQueue.main.async {
            switch key {
            case "water":
                self.dailySumData.today.water = value
            case "caffeine":
                self.dailySumData.today.caffeine = value
            case "basalEnergy":
                self.dailySumData.today.basalEnergy = value
            case "activeEnergy":
                self.dailySumData.today.activeEnergy = value
            case "steps":
                self.dailySumData.today.steps = value
            case "consumedEnergy":
                self.dailySumData.today.consumedEnergy = value
            case "standTime":
                self.dailySumData.today.standTime = value
            case "exerciseTime":
                self.dailySumData.today.exerciseTime = value
            default: print("Key -\(key)- not associated with Daily Sum Data")
            }
        }
    }
    
    func updateDailySumDays(key: String, values: Array<(String, Double)>) {
        DispatchQueue.main.async {
            switch key {
            case "water":
                self.dailySumData.days.water = values
                self.dailySumData.today.water = values.last?.1 ?? 0
            case "caffeine":
                self.dailySumData.days.caffeine = values
                self.dailySumData.today.caffeine = values.last?.1 ?? 0
            case "basalEnergy":
                self.dailySumData.days.basalEnergy = values
                self.dailySumData.today.basalEnergy = values.last?.1 ?? 0
            case "activeEnergy":
                self.dailySumData.days.activeEnergy = values
                self.dailySumData.today.activeEnergy = values.last?.1 ?? 0
            case "steps":
                self.dailySumData.days.steps = values
                self.dailySumData.today.steps = values.last?.1 ?? 0
            case "consumedEnergy":
                self.dailySumData.days.consumedEnergy = values
                self.dailySumData.today.consumedEnergy = values.last?.1 ?? 0
            case "standTime":
                self.dailySumData.days.standTime = values
                self.dailySumData.today.standTime = values.last?.1 ?? 0
            case "exerciseTime":
                self.dailySumData.days.exerciseTime = values
                self.dailySumData.today.exerciseTime = values.last?.1 ?? 0
            default: print("Key -\(key)- not associated with Daily Sum Data")
            }
        }
    }
    
    func updateDailySumWeeks(key: String, values: Array<(String, Double)>) {
        DispatchQueue.main.async {
            switch key {
            case "water":
                self.dailySumData.weeks.water = values
            case "caffeine":
                self.dailySumData.weeks.caffeine = values
            case "basalEnergy":
                self.dailySumData.weeks.basalEnergy = values
            case "activeEnergy":
                self.dailySumData.weeks.activeEnergy = values
            case "steps":
                self.dailySumData.weeks.steps = values
            case "consumedEnergy":
                self.dailySumData.weeks.consumedEnergy = values
            case "standTime":
                self.dailySumData.weeks.standTime = values
            case "exerciseTime":
                self.dailySumData.weeks.exerciseTime = values
                
            default: print("Key -\(key)- not associated with Daily Sum Data")
            }
        }
    }
    
    func updateDailySumMonths(key: String, values: Array<(String, Double)>) {
        DispatchQueue.main.async {
            switch key {
            case "water":
                self.dailySumData.months.water = values
            case "caffeine":
                self.dailySumData.months.caffeine = values
            case "basalEnergy":
                self.dailySumData.months.basalEnergy = values
            case "activeEnergy":
                self.dailySumData.months.activeEnergy = values
            case "steps":
                self.dailySumData.months.steps = values
            case "consumedEnergy":
                self.dailySumData.months.consumedEnergy = values
            case "standTime":
                self.dailySumData.months.standTime = values
            case "exerciseTime":
                self.dailySumData.months.exerciseTime = values
            default: print("Key -\(key)- not associated with Daily Sum Data")
            }
        }
    }
    
    func updateWaterTrackerData(water: Double, caffeine: Double) {
        let dateFormatter = getDateFormatter(format: "EEEE")
        let dayToday = String(dateFormatter.string(from: Date()).prefix(3))
        DispatchQueue.main.async {
            self.dailySumData.today.water += water
            self.dailySumData.today.caffeine += caffeine
            
            self.dailySumData.days.water[self.dailySumData.days.water.count - 1] = (dayToday, self.dailySumData.today.water)
            self.dailySumData.days.caffeine[self.dailySumData.days.caffeine.count - 1] = (dayToday, self.dailySumData.today.caffeine)
        }
    }
    
    
    func updateWorkoutData(workouts: Array<HKWorkout>){
        let distances = getRunningDistances(workouts: workouts)
        let workoutsPerMonth = getWorkoutsPerMonth(workouts: workouts)
        let numberWorkoutsPerWeek = getNumberWeeklyWorkouts(workouts: workouts)
        let numberWorkoutsPerMonth = getNumberMonthlyWorkouts(workoutsPerMonth: workoutsPerMonth)
        
        DispatchQueue.main.async {
            self.workoutData.workoutsPerMonth = workoutsPerMonth
            self.workoutData.numberWorkoutsPerWeek = numberWorkoutsPerWeek
            self.workoutData.numberWorkoutsPerMonth = numberWorkoutsPerMonth
            
            self.workoutData.runningDistanceThisMonth = distances.thisMonth
            self.workoutData.runningDistanceWeeks = distances.weeks
            self.workoutData.runningDistanceMonths = distances.months
        }
    }
    
    func updateWeights(values: Array<Weight>){
        DispatchQueue.main.async {
            self.weights = values.sorted(by: >)
            self.currentWeight = self.weights[0]
        }
    }
    
    func addToTodaysBeverages(selectedBeverage: SelectedBeverage, todaysBeverages: UserDefaults){
        DispatchQueue.main.async {
            self.updateOnDayChange()
            
            self.todaysBeverages.append(selectedBeverage)
            self.updateUserDefaults(userDefaults: todaysBeverages)
        }
    }
    
    func deleteFromTodaysBeverages(selectedBeverage: SelectedBeverage, todaysBeverages: UserDefaults){
        for (index, bev) in self.todaysBeverages.enumerated() {
            if bev.id == selectedBeverage.id {
                self.todaysBeverages.remove(at: index)
                break
            }
        }
        self.updateUserDefaults(userDefaults: todaysBeverages)
    }
    
    func updateUserDefaults(userDefaults: UserDefaults){
        var timestamps: Array<Date> = []
        var beverages: Array<Dictionary<String, String>> = []
        
        for selectedBeverage in self.todaysBeverages {
            timestamps.append(selectedBeverage.timestamp)
            beverages.append(["name": selectedBeverage.beverage.name,
                              "logopath": selectedBeverage.beverage.logopath,
                              "water": String(selectedBeverage.beverage.water),
                              "caffeine": String(selectedBeverage.beverage.caffeine),
                              "amount": String(selectedBeverage.portionsize),
                              "waterUUID": selectedBeverage.waterObjectUUID.uuidString,
                              "caffeineUUID": selectedBeverage.caffeineObjectUUID.uuidString])
        }
        userDefaults.setValue(timestamps, forKey: "timestamps")
        userDefaults.setValue(beverages, forKey: "beverages")
    }
    
    func updateOnDayChange() {
        if self.todaysBeverages.count > 0 {
            let lastDay = Calendar.current.dateComponents([.day],
                                                          from: self.todaysBeverages[0].timestamp)
            let dayToday = Calendar.current.dateComponents([.day],
                                                           from: Date())
            if lastDay != dayToday {
                self.todaysBeverages = []
            }
        }
    }

//    static func == (lhs: DataModel, rhs: DataModel) -> Bool {
//        return
//            lhs.dailySumDataToday == rhs.dailySumDataToday &&
//            lhs.dailySumDataHistory == rhs.dailySumDataHistory
//    }
    
    func setTodaysBeverages(todaysBeverages: UserDefaults){
        if todaysBeverages.array(forKey: "beverages") == nil || todaysBeverages.array(forKey: "timestamps") == nil{
            todaysBeverages.setValue([], forKey: "beverages")
            todaysBeverages.setValue([], forKey: "timestamps")
        }
        let beverages = todaysBeverages.array(forKey: "beverages") as! Array<Dictionary<String,String>>
        let timestamps = todaysBeverages.array(forKey: "timestamps") as! Array<Date>
        
        var selectedBeverages: Array<SelectedBeverage> = []
        for (beverage, timestamp) in zip(beverages, timestamps) {
            let beverageObject = Beverage(name: beverage["name"]!,
                                          logopath: beverage["logopath"]!,
                                          water: Float(beverage["water"]!)!,
                                          caffeine: Float(beverage["caffeine"]!)!)
            let selectedBeverage = SelectedBeverage(beverage: beverageObject,
                                                    portionsize: Int(beverage["amount"]!)!,
                                                    timestamp: timestamp)
            
            selectedBeverage.waterObjectUUID = UUID(uuidString: beverage["waterUUID"]!)!
            selectedBeverage.caffeineObjectUUID = UUID(uuidString: beverage["caffeineUUID"]!)!
            selectedBeverages.append(selectedBeverage)
        }
        self.todaysBeverages = selectedBeverages
        self.updateOnDayChange()
    }
}


class SelectedBeverage:Identifiable {
    let id: UUID = UUID()
    let beverage: Beverage
    let portionsize: Int
    let timestamp: Date
    var waterObjectUUID: UUID = UUID()
    var caffeineObjectUUID: UUID = UUID()
    
    init(beverage: Beverage, portionsize: Int, timestamp: Date){
        self.beverage = beverage
        self.portionsize = portionsize
        self.timestamp = timestamp
    }
}

class Weight: Identifiable, Comparable, Hashable {
    var id: UUID = UUID()
    let weight: Double
    let timestamp: Date
    
    init(weight: Double, timestamp: Date) {
        self.weight = weight
        self.timestamp = timestamp
    }
    
    static func <(lhs: Weight, rhs: Weight) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
    
    static func ==(lhs:Weight, rhs:Weight) -> Bool {
        return lhs.id == rhs.id && lhs.weight == rhs.weight && lhs.timestamp == rhs.timestamp
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}


struct ActivitySummary {
    var summaries: Array<HKActivitySummary?> = []
    var standingHours: Array<Int> = []
    var exerciseTime: Array<Double> = []
    var activeEnergy: Array<Double> = []
    
    
    func getWeeksSummaries(date: Date) -> Array<HKActivitySummary?>{
        let bounds = getWeekDates(date: date)
        let calendar = Calendar.current
        var summariesWeek : Array<HKActivitySummary?> = []
        
        for summary in self.summaries {
            if let summary = summary {
                let summaryTimestamp = calendar.date(from: summary.dateComponents(for: calendar))!
                if  summaryTimestamp >= bounds.start && summaryTimestamp <= bounds.end{
                    summariesWeek.append(summary)
                }
            }
        }
        
        let extraDays = 7 - summariesWeek.count
        for _ in 0 ..< extraDays {
            summariesWeek.append(nil)
        }
        
        print("Summaries: \(summariesWeek.count)")
        return summariesWeek
    }
}

//
//  Utilis.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 03.03.21.
//

import SwiftUI


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

func getDefaultAnchorDate(calendar: Calendar) -> Date {
    var anchorDateComponents = DateComponents()
    anchorDateComponents.year = 2020
    anchorDateComponents.month = 1
    anchorDateComponents.day = 1
    anchorDateComponents.hour = 0
    anchorDateComponents.minute = 0
    anchorDateComponents.second = 0
    
    let anchorDate = calendar.date(from: anchorDateComponents)!
    
    return anchorDate
}

func getRecordingStart() -> Date {
    let calendar = Calendar.current
    
    var dateComponents = calendar.dateComponents([.year, .month, .day, .hour], from: Date())
    dateComponents.year = 2020
    dateComponents.month = 11
    dateComponents.day = 1
    dateComponents.hour = 0
    
    let recordingStart = calendar.date(from: dateComponents)!
    
    return min(recordingStart, getLastSixMonthsStart(date: Date()))
}

func getTodaysBounds() -> (start: Date, end: Date) {
    let calendar = Calendar.current
    let now = Date()
    
    var nowComponents = calendar.dateComponents(Set([.year, .month, .day, .hour, .minute, .second]),
                                                from: now)
    nowComponents.hour = 0
    nowComponents.minute = 0
    nowComponents.second = 0
    let startDate = calendar.date(from: nowComponents)!
    
    nowComponents.day = nowComponents.day! + 1
    let endDate = calendar.date(from: nowComponents)!
    
    return (startDate, endDate)
}

func getLastSixMonthsStart(date: Date) -> Date {
    
    let calendar = Calendar.current
    var componentsNow = calendar.dateComponents([.year, .month, .day, .hour], from: date)
    componentsNow.month = componentsNow.month! - 6
    componentsNow.day = 1
    componentsNow.hour = 0
    
    let startDate = calendar.date(from: componentsNow)!
    
    return startDate
}

func getLastSixWeeksStart(date: Date) -> Date {
    let calendar = Calendar.current
    var componentsNow = calendar.dateComponents([.year, .month, .day, .weekday, .hour], from: date)
    componentsNow.day = componentsNow.day! - (componentsNow.weekday!-2) - 6*7
    componentsNow.hour = 1
    let startDate = calendar.date(from: componentsNow)!
    
    return startDate
}

func getWeekDates(date: Date) -> (start: Date, end: Date, dates: Array<Date>) {
    let calendar = Calendar.current
    
    var dateComponents = calendar.dateComponents([.year, .month, .day, .weekday], from: date)
    let weekday = (dateComponents.weekday!+5) % 7
    dateComponents.day = dateComponents.day! - weekday
    let startDate = calendar.date(from: dateComponents)!
    dateComponents.day = dateComponents.day! + 6
    let endDate = calendar.date(from: dateComponents)!
    
    var dates : Array<Date> = [startDate]
    var previousDate = startDate
    while dates.count < 7 {
        let date = previousDate + 86400
        dates.append(date)
        previousDate = date
    }
        
    return (startDate, endDate, dates)
}


func getWeeklyBounds(start: Date) -> Array<(Date, Date)> {
    let calendar = Calendar.current
    var weekStart = start
    var weeklyBounds : Array<(Date, Date)> = []
    while weekStart <= Date() {
        var components = calendar.dateComponents([.year, .month, .day], from: weekStart)
        components.day = components.day! + 7
        let weekEnd = calendar.date(from: components)!
        weeklyBounds.append((weekStart, weekEnd))
        weekStart = weekEnd
    }
    return weeklyBounds
}

func getThisMonthStart(date: Date) -> Date {
    let calendar = Calendar.current
    
    var nowComponents = calendar.dateComponents(Set([.year, .month, .day, .hour, .minute, .second]),
                                                from: date)
    nowComponents.day = 1
    nowComponents.hour = 0
    nowComponents.minute = 0
    nowComponents.second = 0
    let startDate = calendar.date(from: nowComponents)!
    
    return startDate
}

func getMonthsEnd(date: Date) -> Date {
    let calendar = Calendar.current
    var components = calendar.dateComponents([.year, .month, .day], from: date)
    
    components.month = components.month! + 1
    components.day = 1
    
    let monthsEnd = calendar.date(from: components)!
    return monthsEnd
}

func getLastDaysStart(date: Date) -> Date {
    let calendar = Calendar.current
    
    var nowComponents = calendar.dateComponents(Set([.year, .month, .day, .hour, .minute, .second]),
                                                from: date)
    nowComponents.hour = 0
    nowComponents.minute = 0
    nowComponents.second = 0
    nowComponents.day = nowComponents.day! - 7
    let startDate = calendar.date(from: nowComponents)!
    
    return startDate
}

func get2020Start() -> Date {
    let calendar = Calendar.current
    let now = Date()
    
    var nowComponents = calendar.dateComponents([.era, .year, .day, .month, .hour], from: now)
    nowComponents.year = 2020
    nowComponents.month = 1
    nowComponents.day = 1
    nowComponents.hour = 0
    
    let startDate = calendar.date(from: nowComponents)!
    
    return startDate
}

func getDateFormatter(format: String) -> DateFormatter {
    let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter
    }()
    return dateFormatter
}

func timeDoubleToString(time: Double) -> String {
    let hours: Double = time/60
    let minutes: Double = hours > 1.0 ? 60*(hours - floor(hours)) : time
    let seconds: Double = 60*(minutes - floor(minutes))
    
    let hoursString = hours>1 ? "\(String(format: "%.0f", floor(hours))):" : ""
    let minutesString = minutes>1 ? "\(String(format: "%.0f", floor(minutes))):" : ""
    let secondsString = String(format: "%.0f", seconds)
    
    let insertMinutesZero = hours>1 && minutes < 10 ? "0": ""
    let insertSecondsZero = minutes > 1 && seconds < 10 ? "0" : ""
    
    let timeString = "\(hoursString)\(insertMinutesZero)\(minutesString)\(insertSecondsZero)\(secondsString)"
    return timeString
}

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate)
        
        return numberOfDays.day! + 1 // <1>
    }
}

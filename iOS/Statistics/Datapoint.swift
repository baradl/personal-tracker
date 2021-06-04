//
//  Datapoint.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 30.03.21.
//

import Foundation


func toDatapoints(data: Array<Double>, startDate: Date) -> Array<Datapoint> {
    var nextDate: Date
    var index = 0
    let calendar = Calendar.current
    var datapoints : Array<Datapoint> = []
    
    if !data.isEmpty{
        nextDate = startDate
        datapoints.append(Datapoint(value: data[index+1], timestamp: nextDate))
        index += 1
    }
    
    let endDate = Date()
    if data.count == (calendar.numberOfDaysBetween(startDate, and: Date())) {
        calendar.enumerateDates(startingAfter: startDate,
                                matching: DateComponents(hour: 0, minute: 0, second:0),
                                matchingPolicy: .nextTime){ (date, _, stop) in
            
            var nextDate: Date
            nextDate = date!
            
            if nextDate >= endDate {
                stop = true
                return
            }
                        
            
            datapoints.append(Datapoint(value: data[index], timestamp: nextDate))
            index += 1
        }
    }
    return datapoints
}

struct Datapoint: Identifiable {
    let value:Double
    let timestamp:Date
    let id: UUID = UUID()
    
    init(value: Double, timestamp: Date){
        self.value = value
        self.timestamp = timestamp
    }
}

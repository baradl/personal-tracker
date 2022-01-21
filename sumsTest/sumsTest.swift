//
//  sumsTest.swift
//  sumsTest
//
//  Created by Bastian Radloff on 21.01.22.
//

import XCTest
import HealthKit
@testable import personal_tracker

class sumsTest: XCTestCase {
    func testGetActiveLastDays () {
        let workouts: Array<HKWorkout> = []
        
        print(getActiveLastDays(workouts: workouts))
    }
}

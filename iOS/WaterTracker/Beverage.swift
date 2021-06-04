//
//  Beverage.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 22.03.21.
//

import Foundation

class Beverage : Identifiable {
    let id: UUID = UUID()
    let name: String
    let logopath: String
    var caffeine: Float
    var water: Float
    var portionsizes: [Int] = []
    
    
    init(name: String, logopath: String, water: Float, caffeine: Float){
        self.name = name
        self.logopath = logopath
        self.water = water
        self.caffeine = caffeine
    }
    
    init(name: String,
         logopath: String,
         caffeine: Float,
         water: Float,
         portionsizes: [Int]) {
        self.caffeine = caffeine
        self.water = water
        self.name = name
        self.logopath = logopath
        self.portionsizes = portionsizes
    }
}

func createBeverages()->[Beverage]{
    var beverages: [Beverage] = []
    
    let water = Beverage(name: "Water",
                         logopath: "water-glass",
                         caffeine: 0.0,
                         water: 1.0,
                         portionsizes: [750, 1200])
    beverages.append(water)
    let coffee = Beverage(name: "Coffee",
                          logopath: "coffee",
                          caffeine: 0.4,
                          water: 0.8,
                          portionsizes: [250, 300])
    beverages.append(coffee)
    let tea = Beverage(name: "Tea",
                        logopath: "tea",
                        caffeine: 0.0,
                        water: 1.0,
                        portionsizes: [300, 400, 500])
    beverages.append(tea)
//    let espresso = Beverage(name: "Espresso",
//                            logopath: "espresso",
//                            caffeine: 1.33,
//                            water: 0.8,
//                          portionsizes: [25, 50])
//    beverages.append(espresso)
    
    
    let soda = Beverage(name: "Soda",
                        logopath: "soft-drink",
                        caffeine: 0.0,
                        water: 0.85,
                        portionsizes: [250, 330, 500])
    beverages.append(soda)
    let coke = Beverage(name: "Coca Cola",
                        logopath: "cola",
                        caffeine: 0.1,
                        water: 0.85,
                        portionsizes: [250, 330, 500])
    beverages.append(coke)
    let redbull = Beverage(name: "RedBull",
                           logopath: "redbull",
                           caffeine: 0.3,
                           water: 0.85,
                           portionsizes: [250, 330, 500])
    beverages.append(redbull)
    let monster = Beverage(name: "Monster NRG",
                           logopath: "cthulhu",
                           caffeine: 0.36,
                           water: 0.85,
                           portionsizes: [500])
    beverages.append(monster)
    let bang = Beverage(name: "Bang NRG",
                        logopath: "bang",
                        caffeine: 0.32,
                        water: 0.85,
                        portionsizes: [500])
    beverages.append(bang)
    let rockstar = Beverage(name: "Rockstar NRG",
                        logopath: "rock",
                        caffeine: 0.32,
                        water: 0.85,
                        portionsizes: [500])
    beverages.append(rockstar)
    return beverages
}

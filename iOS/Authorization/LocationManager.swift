//
//  LocationManager.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 30.03.21.
//

import MapKit

func getLocationManager() -> CLLocationManager {
    let manager = CLLocationManager()
    
    guard CLLocationManager.locationServicesEnabled() else {
        fatalError("Something went wrong")
    }

    if manager.authorizationStatus == .notDetermined {
        manager.requestWhenInUseAuthorization()
    } else {
        manager.requestLocation()
    }
    
    return manager
}

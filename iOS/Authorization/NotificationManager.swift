//
//  NotificationManager.swift
//  personal_tracker (iOS)
//
//  Created by Bastian Radloff on 31.03.21.
//


import UserNotifications


class NotificationManager{
    
    init(){
        requestNotificationAuthorization()
    }
    
    func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("*** Authorization of Notifications succesful ***")
            } else if let error = error {
                fatalError("An error occurred: \(error.localizedDescription)")
            }
        }
    }
}


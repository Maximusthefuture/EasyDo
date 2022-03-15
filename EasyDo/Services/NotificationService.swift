//
//  NotificationService.swift
//  EasyDo
//
//  Created by Maximus on 13.03.2022.
//

import Foundation
import UserNotifications


class NotificationManager {
    
    static let shared = NotificationManager()
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                completion(granted)
            }
    }
    
    func fetchNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("setting", settings)
        }
    }
    
    func scheduleNotification(time: Date?, dailyTask: DailyItems) {
        var trigger: UNCalendarNotificationTrigger?
        let content = UNMutableNotificationContent()
        content.title = dailyTask.task?.title ?? "Title"
        content.body = dailyTask.task?.taskDescription ?? "Body"
        content.categoryIdentifier = "CategoryHere"
        if let date = time {
  
         trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents(
            [.month, .day, .hour, .minute], from:  date), repeats: false)
        }
        
        let request = UNNotificationRequest(identifier: dailyTask.task?.description ?? "", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
}

//
//  LocalPushManager.swift
//  Noti
//
//  Created by Seti Vega on 12/23/18.
//  Copyright © 2018 SetiVega. All rights reserved.
//

import Foundation
import UserNotifications

class LocalPushManager: NSObject {
    static var shared = LocalPushManager()
    let center = UNUserNotificationCenter.current()
    
    func requestAuthorization(){
        center.requestAuthorization(options: [.badge,.alert,.sound]) { (sucess, error) in
            if error != nil{
                print("Auhtorization Unsuccessful")
            }
            else{
                print("Auhtorization Successful")
            }
        }
    }
    
    func sendLocalPush(title: String, body: String, repeating: Bool, components: DateComponents, interval: TimeInterval, type: Type){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = nil
        
        let trigger : UNNotificationTrigger!
        
        if type == .interval{
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: repeating)
        }else{
            trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeating)
        }
        
        let request = UNNotificationRequest(identifier: title, content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if error != nil{
                print("Error: \(String(describing: error?.localizedDescription))")
            }
            else{
                self.getPendingNotifs()
            }
        }
        
    }
    
    func updateLocalPush(title: String, body: String, repeating: Bool, components: DateComponents, interval: TimeInterval, type: Type){
        deleteLocalPush(title: title)
        sendLocalPush(title: title, body: body, repeating: repeating, components: components, interval: interval, type: type)
    }
    
    func deleteLocalPush(title: String){
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [title])
    }
    
    func getPendingNotifs(){
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {pendingRequests in
            print("Pending notifications: \(pendingRequests)")
        })
    }
    
}

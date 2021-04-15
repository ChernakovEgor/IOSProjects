//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Egor Chernakov on 05.04.2021.
//

import UserNotifications
import UIKit

class ViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    var timeInterval: Double!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeInterval = 5
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }

    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (isGranted, error) in
            if isGranted {
                print("Permission granted")
            } else {
                print("Permission denied. Error: \(error?.localizedDescription ?? "")")
            }
        }
        
    }

    @objc func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        registerCategories()
        
        let content = UNMutableNotificationContent()
        content.title = "Good Morning"
        content.body = "If you are going through hell, keep going."
        content.sound = .default
        content.userInfo = ["customData" : "someData"]
        content.categoryIdentifier = "alarm"
        
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
        timeInterval = 5
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Who said that?", options: .foreground)
        let postpone = UNNotificationAction(identifier: "postpone", title: "Remind me later...", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, postpone], intentIdentifiers: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] {
            print("Data recieved: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("default")
            case "show":
                print("show")
            case "postpone":
                timeInterval = 10
                scheduleLocal()
            default:
                break
            }
        }
        
        completionHandler()
    }
}


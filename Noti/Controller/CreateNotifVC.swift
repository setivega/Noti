//
//  CreateNotifVC.swift
//  Noti
//
//  Created by Seti Vega on 12/2/18.
//  Copyright © 2018 SetiVega. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

enum Type: Int16 {
    case interval = 0
    case daily = 1
    case weekly = 2
}

class CreateNotifVC: UIViewController {
    
    var notifTitle: String?
    var notifMessage: String?
    var notifRepeating: Bool = false
    var notifState: Bool = true
    var notifComponents = DateComponents()
    var notifInterval = TimeInterval()
    var notifType: Type?
    var notifDate = Date()
    var dateString = String()
    
    var weekday : Int = 1
    var hour: Int = 0
    var minute: Int = 1
    
    @IBOutlet weak var repeatSwitch: UISwitch!
    @IBOutlet weak var notifTimePicker: UIDatePicker!
    @IBOutlet weak var weekSegmentedController: CustomSegementedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        weekSegmentedController.isHidden = true
        getTimeInterval()
        
    }
    
    
    @IBAction func repeatSwitchPressed(_ sender: Any) {
        if repeatSwitch.isOn {
            notifRepeating = true
        }
        else if repeatSwitch.isOn == false{
            notifRepeating = false
        }
    }
    
    
    func getTimeInterval() {
        updateDateComponents()
        if notifType == .interval{
            notifInterval = notifTimePicker.countDownDuration
            print(notifInterval)
        }
        else if notifType == .daily {
            notifComponents.weekday = nil
            notifComponents.hour = hour
            notifComponents.minute = minute
            print(notifComponents)
        }
        else if notifType == .weekly{
            notifComponents.weekday = weekday
            notifComponents.hour = hour
            notifComponents.minute = minute
            print(notifComponents)
        }
    }
    
    
    @IBAction func pickerSegmentChangedValue(_ sender: CustomSegementedControl) {
        
        switch sender.selectedSegmentIndex{
        case 1:
            notifTimePicker.datePickerMode = .time
            weekSegmentedController.isHidden = true
            notifType = .daily
            print("daily")
            getTimeInterval()
        case 2:
            notifTimePicker.datePickerMode = .time
            weekSegmentedController.isHidden = false
            notifType = .weekly
            print("weekly")
            getTimeInterval()
        default:
            notifTimePicker.datePickerMode = .countDownTimer
            weekSegmentedController.isHidden = true
            notifType = .interval
            print("interval")
            getTimeInterval()
        }

        
    }
    
    @IBAction func weekSegmentChangedValue(_ sender: CustomSegementedControl) {
        
        switch sender.selectedSegmentIndex{
            case 1:
                weekday = 2
            case 2:
                weekday = 3
            case 3:
                weekday = 4
            case 4:
                weekday = 5
            case 5:
                weekday = 6
            case 6:
                weekday = 7
            default:
                weekday = 1
        }
        getTimeInterval()
    }
    
    func formatTime(interval: TimeInterval, components: DateComponents, repeating: Bool, type: Type){
        
        if type == .interval{
            let intervalString = interval.stringTime
            if repeating{
                dateString = "Every \(intervalString)"
            }else{
                dateString = "In \(intervalString)"
            }
            print(dateString)
        }
        else if type == .daily{
            let calendar = Calendar(identifier: .gregorian)
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            if let date = calendar.date(from: components){
                if repeating{
                    dateString = "Daily at \(formatter.string(from: date))"
                }else{
                    dateString = "Scheduled for \(formatter.string(from: date))"
                }
                print(dateString)
            }
            
        }
        else{
            let calendar = Calendar(identifier: .gregorian)
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE 'at' h:mm a"
            if let date = calendar.date(from: components){
                if repeating{
                    dateString = "Every \(formatter.string(from: date))"
                }else{
                    dateString = "\(formatter.string(from: date))"
                }
                print(dateString)
            }
        }
        
        
    }
    
    
    func updateDateComponents(){
        
        let date = notifTimePicker.date
        
        let components = Calendar.current.dateComponents([.day,.hour,.minute], from: date)

        hour = components.hour!
        minute = components.minute!
    
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        getTimeInterval()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func createNotifButtonPressed(_ sender: Any) {
        
        if let type = notifType{
            formatTime(interval: notifInterval, components: notifComponents, repeating: notifRepeating, type: type)
        }
        
        let date = Calendar.current.date(from: notifComponents)
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Notification", in: context)
        if let notification = entity {
            let newEntity = NSManagedObject(entity: notification, insertInto: context)
            newEntity.setValue(notifTitle, forKey: "title")
            newEntity.setValue(notifMessage, forKey: "message")
            newEntity.setValue(notifRepeating, forKey: "repeating")
            newEntity.setValue(notifState, forKey: "state")
            newEntity.setValue(notifDate, forKey: "dateCreated")
            newEntity.setValue(dateString, forKey: "dateString")
            newEntity.setValue(notifType?.rawValue, forKey: "type")
            newEntity.setValue(notifInterval, forKey: "interval")
            if let fireDate = date{
                newEntity.setValue(fireDate, forKey: "fireDate")
            }
            
            do{
                try context.save()
                print(notifComponents)
                if let title = notifTitle, let body = notifMessage, let type = notifType{
                    LocalPushManager.shared.sendLocalPush(title: title, body: body, repeating: notifRepeating, components: notifComponents, interval: notifInterval ,type: type)
                }
                print("saved successfully")
                print(notifDate.description)
            } catch let err{
                print("Error: \(err.localizedDescription)")
            }
        }
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)

        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }


}

extension TimeInterval {
    
    private var minutes: Int {
        return (Int(self) / 60 ) % 60
    }
    
    private var hours: Int {
        return Int(self) / 3600
    }
    
    var stringTime: String {
        if hours != 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}


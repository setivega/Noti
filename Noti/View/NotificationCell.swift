//
//  NotificationCell.swift
//  Noti
//
//  Created by Seti Vega on 12/3/18.
//  Copyright © 2018 SetiVega. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
        
    @IBOutlet weak var notificationTitle: UILabel!
    @IBOutlet weak var notificationMessage: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var notificationTime: UILabel!
    @IBOutlet weak var editIcon: UIButton!
    
    var fireDate : Date?
    var rawType = Int16()
    
    
    
    var repeating = Bool()
    var interval = TimeInterval()
    var state = Bool()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        if state{
//            notificationSwitch.isOn = true
//        }else if state == false{
//            notificationSwitch.isOn = false
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
//    @IBAction func cellStateChanged(_ sender: Any) {
//        if notificationSwitch.isOn == false{
//            if let title = notificationTitle.text{
//            LocalPushManager.shared.deleteLocalPush(title: title)
//            }
//            print("Noti Disabled")
//            state = false
//        }
//
//        var components = DateComponents()
//
//        if notificationSwitch.isOn{
//            print(components)
//            var notifType : Type?
//
//            switch rawType{
//                case 0:
//                    notifType = .interval
//                case 1:
//                    notifType = .daily
//                case 2:
//                    notifType = .weekly
//            default:
//                    notifType = .interval
//            }
//
//            if let title = notificationTitle.text, let body = notificationMessage.text, let type = notifType, let date = fireDate {
//                switch type{
//                case .daily:
//                    components = Calendar.current.dateComponents([.hour,.minute], from: date)
//                case .weekly:
//                    components = Calendar.current.dateComponents([.day,.hour,.minute], from: date)
//                default:
//                    components = Calendar.current.dateComponents([.hour,.minute], from: date)
//                }
//                LocalPushManager.shared.sendLocalPush(title: title, body: body, repeating: repeating, components: components, interval: interval, type: type)
//            }
//            print("Noti Reenabled")
//            state = true
//        }
//    }


}

//
//  Notification+CoreDataProperties.swift
//  Noti
//
//  Created by Seti Vega on 12/8/18.
//  Copyright © 2018 SetiVega. All rights reserved.
//
//

import Foundation
import CoreData


extension Notification {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Notification> {
        return NSFetchRequest<Notification>(entityName: "Notification")
    }

    @NSManaged public var title: String
    @NSManaged public var message: String
    @NSManaged public var repeating: Bool
    @NSManaged public var state: Bool
    @NSManaged public var interval: Double
    @NSManaged public var fireDate: Date
    @NSManaged public var dateCreated: Date
    @NSManaged public var dateString: String
    @NSManaged public var type: Int16

}

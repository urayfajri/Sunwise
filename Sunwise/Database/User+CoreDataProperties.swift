//
//  User+CoreDataProperties.swift
//  Sunwise
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 28/12/22.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var sunbath_goal: Int32
    @NSManaged public var skin_type: String?
    @NSManaged public var ideal_time_notif: Bool
    @NSManaged public var sun_protection_notif: Bool
    @NSManaged public var dailySunbathes: NSSet?

}

// MARK: Generated accessors for dailySunbathes
extension User {

    @objc(addDailySunbathesObject:)
    @NSManaged public func addToDailySunbathes(_ value: DailySunbathe)

    @objc(removeDailySunbathesObject:)
    @NSManaged public func removeFromDailySunbathes(_ value: DailySunbathe)

    @objc(addDailySunbathes:)
    @NSManaged public func addToDailySunbathes(_ values: NSSet)

    @objc(removeDailySunbathes:)
    @NSManaged public func removeFromDailySunbathes(_ values: NSSet)

}

extension User : Identifiable {

}

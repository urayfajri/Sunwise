//
//  DailySunbathe+CoreDataProperties.swift
//  Sunwise
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 02/01/23.
//
//

import Foundation
import CoreData


extension DailySunbathe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailySunbathe> {
        return NSFetchRequest<DailySunbathe>(entityName: "DailySunbathe")
    }

    @NSManaged public var achieve_time: Date?
    @NSManaged public var date: Date?
    @NSManaged public var target_time: Date?
    @NSManaged public var sessions: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for sessions
extension DailySunbathe {

    @objc(addSessionsObject:)
    @NSManaged public func addToSessions(_ value: Session)

    @objc(removeSessionsObject:)
    @NSManaged public func removeFromSessions(_ value: Session)

    @objc(addSessions:)
    @NSManaged public func addToSessions(_ values: NSSet)

    @objc(removeSessions:)
    @NSManaged public func removeFromSessions(_ values: NSSet)

}

extension DailySunbathe : Identifiable {

}

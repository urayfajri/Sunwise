//
//  Session+CoreDataProperties.swift
//  Sunwise
//
//  Created by Uray Muhamad Noor Fajri Widiansyah on 28/12/22.
//
//

import Foundation
import CoreData


extension Session {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Session> {
        return NSFetchRequest<Session>(entityName: "Session")
    }

    @NSManaged public var duration: Date?
    @NSManaged public var finish_time: Date?
    @NSManaged public var start_time: Date?
    @NSManaged public var location: String?
    @NSManaged public var uv_index: Int32
    @NSManaged public var temp: Double
    @NSManaged public var weather: String?
    @NSManaged public var dailySunbathe: DailySunbathe?

}

extension Session : Identifiable {

}

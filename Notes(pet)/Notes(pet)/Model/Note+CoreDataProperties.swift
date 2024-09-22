//
//  Note+CoreDataProperties.swift
//  Notes(pet)
//
//  Created by Danil Pestov on 22.09.2024.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var createdDate: Date?

}

extension Note : Identifiable {

}

//
//  Note.swift
//  Notes(pet)
//
//  Created by Danil Pestov on 16.09.2024.
//

import CoreData

public class Note: NSManagedObject {
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var dateCreated: Date?
}

extension Note {
    static func fetchAllNotesRequest() -> NSFetchRequest<Note> {
        let request = NSFetchRequest<Note>(entityName: "Note")
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        return request
    }
}

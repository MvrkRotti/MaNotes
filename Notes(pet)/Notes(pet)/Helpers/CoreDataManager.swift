//
//  CoreDataManager.swift
//  Notes(pet)
//
//  Created by Danil Pestov on 16.09.2024.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Notes(pet)")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistant container \(error)")
            }
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
    func createNote(title: String, content: String) {
        let note = Note(context: persistentContainer.viewContext)
        note.title = title
        note.content = content
        note.dateCreated = Date()
        saveContext()
    }
    
    func deleteNote(_ note: Note) {
        persistentContainer.viewContext.delete(note)
        saveContext()
    }
    
    func fetchNotes() -> [Note] {
        let requset: NSFetchRequest<Note> = Note.fetchAllNotesRequest()
        do {
            return try persistentContainer.viewContext.fetch(requset)
        } catch {
            print("Failed to fetch notes: \(error)")
            return []
        }
    }
}

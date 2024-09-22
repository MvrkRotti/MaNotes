//
//  NotesViewModel.swift
//  Notes(pet)
//
//  Created by Danil Pestov on 18.09.2024.
//

import UIKit
import CoreData

class NotesViewModel {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistancContainer.viewContext
    var notes: [Note] = []
    
    func fetchNotes() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        do {
            notes = try context.fetch(request)
        } catch {
            print("Failed to fetch notes: \(error)")
        }
    }
    
    func saveContext() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func deleteNote(at index: Int) {
        let noteToDelete = notes[index]
        context.delete(noteToDelete)
        saveContext()
        fetchNotes()
    }
}

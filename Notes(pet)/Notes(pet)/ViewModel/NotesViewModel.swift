//
//  NotesViewModel.swift
//  Notes(pet)
//
//  Created by Danil Pestov on 18.09.2024.
//

import UIKit
import CoreData

enum SortType {
    case title
    case date
}

class NotesViewModel {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistancContainer.viewContext
    var filteredNotes: [Note] = []
    var notes: [Note] = []
    
    func fetchNotes() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        do {
            notes = try context.fetch(request)
            filteredNotes = notes
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
    
    func sortNotes(by type: SortType) {
        switch type {
        case .title:
            notes.sort { $0.title?.localizedCaseInsensitiveCompare($1.title ?? "") == .orderedAscending }
        case .date:
            notes.sort { $0.createdDate ?? Date() < $1.createdDate ?? Date() }
        }
    }
    
    func filterNotes(with query: String) {
        if query.isEmpty {
            filteredNotes = notes
        } else {
            filteredNotes = notes.filter { note in
                note.title?.lowercased().contains(query.lowercased()) ?? false ||
                note.content?.lowercased().contains(query.lowercased()) ?? false
            }
        }
    }
}

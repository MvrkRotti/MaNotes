//
//  NotesViewModel.swift
//  Notes(pet)
//
//  Created by Danil Pestov on 18.09.2024.
//

import Foundation

class NotesViewModel {
    private var coreDataManager = CoreDataManager.shared
    var notes: [Note] = []
    
    func fetchNotes() {
        notes = coreDataManager.fetchNotes()
    }
    
    func addNote(title: String, content: String) {
        coreDataManager.createNote(title: title, content: content)
        fetchNotes()
    }
    
    func deleteNote(at index: Int) {
        let note = notes[index]
        coreDataManager.deleteNote(note)
        fetchNotes()
    }
}

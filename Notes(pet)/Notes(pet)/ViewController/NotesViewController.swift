//
//  ViewController.swift
//  Notes(pet)
//
//  Created by Danil Pestov on 16.09.2024.
//

import UIKit
import SnapKit

class NotesViewController: UIViewController {
    
    private var viewModel = NotesViewModel()
    private var tableView = UITableView()
    private var addNoteButton = AddNoteButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchNotes()
    }

    
}


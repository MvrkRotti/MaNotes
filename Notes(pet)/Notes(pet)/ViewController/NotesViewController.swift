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
    private var bottomView = UIView()
    private var addNoteButton = AddNoteButton()
    private var sortButton = BottomSideButton(type: .sort)
    private var searchButton = BottomSideButton(type: .search)

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchNotes()
    }
}



//
//  ViewController.swift
//  Notes(pet)
//
//  Created by Danil Pestov on 16.09.2024.
//

import UIKit
import SnapKit

class NotesViewController: UIViewController {
    
    //MARK: - Variables
    
    private let viewModel = NotesViewModel()
    private let notesList = UITableView()
    private let addNoteButton = AddNoteButton()
    private let sortButton = BottomSideButton(type: .sort)
    private let searchButton = BottomSideButton(type: .search)
    
    private let bottomView: UIView = {
        let view = UIView()
        view.alpha = 0.6
        view.layer.borderWidth = 1
        view.layer.borderColor = ColorResources.black.cgColor
        view.backgroundColor = ColorResources.lightGray
        return view
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchNotes()
        tableViewSetting()
        setupUI()
    }
}

private extension NotesViewController {
    //MARK: - SetupUI
    func setupUI() {
        title = "Заметки"
        
        view.backgroundColor = ColorResources.white
        
        view.addSubview(notesList)
        addNavigationBarSeparator()
        view.addSubview(bottomView)
        view.addSubview(addNoteButton)
        view.addSubview(sortButton)
        view.addSubview(searchButton)
        
        notesList.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(-2)
            make.height.equalTo(view.frame.height / 10)
        }
        
        addNoteButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(view.frame.height / 11)
            make.bottom.equalToSuperview().offset(-view.frame.height / 31)
        }
        
        sortButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-view.frame.height / 23)
            make.left.equalToSuperview().offset(view.frame.width / 7.5)
        }
        
        searchButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-view.frame.height / 23)
            make.right.equalToSuperview().offset(-view.frame.width / 7.5)
        }
    }
    
    //MARK: - TableVIew settings
    func tableViewSetting() {
        notesList.dataSource = self
        notesList.delegate = self
        notesList.separatorStyle = .none
        notesList.register(NoteCell.self, forCellReuseIdentifier: NoteCell.identifier)
    }
}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notesList.dequeueReusableCell(withIdentifier: NoteCell.identifier, for: indexPath) as! NoteCell
        cell.configureCell(with: "Hello", content: "test")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.height / 10
    }
}



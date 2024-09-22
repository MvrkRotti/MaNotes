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
    private let noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "Здесь пока что пусто. Самое время добавить первую заметку."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = ColorResources.black
        label.isHidden = true
        return label
    }()
    
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
        checkData()
        tableViewSetting()
        setupUI()
        setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchNotes()
        notesList.reloadData()
        checkData()
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
        view.addSubview(noDataLabel)
        
        noDataLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
        }
        
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
    
    func checkData() {
        if viewModel.notes.isEmpty {
            noDataLabel.isHidden = false
            notesList.isHidden = true
        } else {
            noDataLabel.isHidden = true
            notesList.isHidden = false
        }
    }
    
    func setupAction() {
        addNoteButton.addTarget(self, action: #selector(addNote), for: .touchUpInside)
        sortButton.addTarget(self, action: #selector(showSortOptions), for: .touchUpInside)
    }
    
    @objc func addNote() {
        let noteDetailVC = AddNoteViewController()
        noteDetailVC.onNoteAdded = { [weak self] in
            self?.viewModel.fetchNotes()
            self?.notesList.reloadData()
            self?.checkData()
        }
        navigationController?.pushViewController(noteDetailVC, animated: true)
    }
    
    @objc func showSortOptions() {
        let actionSheet = UIAlertController(title: "Сортировать заметки", message: "Выберите способ сортировки", preferredStyle: .actionSheet)
        
        let sortByTitleAction = UIAlertAction(title: "По алфавиту", style: .default) { [weak self] _ in
            self?.viewModel.sortNotes(by: .title)
            self?.notesList.reloadData()
        }
        
        let sortByDateAction = UIAlertAction(title: "По дате создания", style: .default) { [weak self] _ in
            self?.viewModel.sortNotes(by: .date)
            self?.notesList.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        actionSheet.addAction(sortByDateAction)
        actionSheet.addAction(sortByTitleAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notesList.dequeueReusableCell(withIdentifier: NoteCell.identifier, for: indexPath) as! NoteCell
        let note = viewModel.notes[indexPath.row]
        if let title = note.title, let content = note.content {
            cell.configureCell(with: title, content: content)
        } else {
            cell.configureCell(with: "", content: "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        notesList.deselectRow(at: indexPath, animated: true)
        let note = viewModel.notes[indexPath.row]
        let detailVC = NoteDetailViewController()
        detailVC.note = note
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: NoteCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteNote(at: indexPath.row)
            notesList.deleteRows(at: [indexPath], with: .automatic)
            checkData()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Удалить"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.height / 10
    }
}



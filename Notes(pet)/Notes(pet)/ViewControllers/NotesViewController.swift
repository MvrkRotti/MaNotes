//
//  ViewController.swift
//  Notes(pet)
//
//  Created by Danil Pestov on 16.09.2024.
//

import UIKit
import SnapKit

final class NotesViewController: UIViewController {
    
    //MARK: - Variables
    
    private let viewModel = NotesViewModel()
    private let notesList = UITableView()
    private let addNoteButton = AddNoteButton()
    private let sortButton = BottomSideButton(type: .sort)
    private let searchButton = BottomSideButton(type: .search)
    private let noDataLabel: UILabel = {
        let label = UILabel()
        label.text = Const.noNotesLabel
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
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = Const.searchText
        searchBar.isHidden = true
        searchBar.layer.cornerRadius = 15
        searchBar.searchTextField.leftView = nil
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchNotes()
        checkData()
        tableViewSetting()
        searchBar.delegate = self
        setupUI()
        setupLayout()
        setupAction()
        setupHideKeyboardOnTap()
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
        title = Const.notesTitle
        
        view.backgroundColor = ColorResources.white
        
        view.addSubview(notesList)
        addNavigationBarSeparator()
        view.addSubview(bottomView)
        view.addSubview(addNoteButton)
        view.addSubview(sortButton)
        view.addSubview(searchButton)
        view.addSubview(noDataLabel)
        view.addSubview(searchBar)
    }
    
    func setupLayout() {
        noDataLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
        }
        
        notesList.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview().inset(-2)
            make.height.equalTo(view.frame.height / 9)
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
        searchButton.addTarget(self, action: #selector(toggleSearchBaс), for: .touchUpInside)
    }
    
    @objc func addNote() {
        let noteDetailVC = AddNoteViewController(scanService: ScanServiceImpl())
        noteDetailVC.onNoteAdded = { [weak self] in
            self?.viewModel.fetchNotes()
            self?.notesList.reloadData()
            self?.checkData()
        }
        navigationController?.pushViewController(noteDetailVC, animated: true)
    }
    
    @objc func showSortOptions() {
        let actionSheet = UIAlertController(title: Const.sortTitle, message: Const.sortSubtitle, preferredStyle: .actionSheet)
        
        let sortByTitleAction = UIAlertAction(title: Const.alphabetSort, style: .default) { [weak self] _ in
            self?.viewModel.sortNotes(by: .title)
            self?.notesList.reloadData()
        }
        
        let sortByDateAction = UIAlertAction(title: Const.dateSort, style: .default) { [weak self] _ in
            self?.viewModel.sortNotes(by: .date)
            self?.notesList.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: Const.cancelButtonTitle, style: .cancel, handler: nil)
        
        actionSheet.addAction(sortByDateAction)
        actionSheet.addAction(sortByTitleAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    @objc private func toggleSearchBaс() {
        if searchBar.isHidden {
            searchBar.isHidden = false
            searchBar.alpha = 0
            searchBar.transform = CGAffineTransform(translationX: 0, y: -20)
            
            searchBar.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
                make.height.equalTo(view.frame.height / 18.5)
            }
            
            notesList.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(searchBar.snp.bottom)
                make.bottom.equalTo(bottomView.snp.top)
            }
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.searchBar.alpha = 1
                self.searchBar.transform = .identity
                self.view.layoutIfNeeded()
            }) { _ in
                self.searchBar.becomeFirstResponder()
            }
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.searchBar.alpha = 0
                self.searchBar.transform = CGAffineTransform(translationX: 0, y: -20)
                
                self.notesList.snp.remakeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                    make.bottom.equalTo(self.bottomView.snp.top)
                }
                self.view.layoutIfNeeded()
            }) { _ in
                self.searchBar.isHidden = true
                self.searchBar.resignFirstResponder()
                self.viewModel.filteredNotes = self.viewModel.notes
                self.notesList.reloadData()
            }
        }
    }
    
}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notesList.dequeueReusableCell(withIdentifier: NoteCell.identifier, for: indexPath) as! NoteCell
        let note = viewModel.filteredNotes[indexPath.row]
        if let title = note.title, let content = note.content {
            cell.configureCell(with: title, content: content)
        } else {
            cell.configureCell(with: "", content: "")
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        notesList.deselectRow(at: indexPath, animated: true)
        let note = viewModel.notes[indexPath.row]
        let detailVC = NoteDetailViewController()
        detailVC.note = note
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        UIView.animate(withDuration: 0.02, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                cell.transform = CGAffineTransform.identity
            }) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.09) {
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
        }
    }
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: NoteCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            viewModel.deleteNote(at: indexPath.row)
    //            notesList.deleteRows(at: [indexPath], with: .automatic)
    //            checkData()
    //        }
    //    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeAction = UIContextualAction(
            style: .destructive,
            title: nil,
            handler: { [weak self] (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
                guard let self else { return }
                viewModel.deleteNote(at: indexPath.row)
                notesList.deleteRows(at: [indexPath], with: .automatic)
                checkData()
                success(true)
            }
        )
        
        removeAction.image = UIImage(named: "deleteIconImage")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        removeAction.backgroundColor = .white
        
        return UISwipeActionsConfiguration(actions: [removeAction])
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return Const.deleteButtonTitle
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        view.frame.height / 10
    }
}

extension NotesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterNotes(with: searchText)
        notesList.reloadData()
    }
}



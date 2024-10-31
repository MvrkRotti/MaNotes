//
//  NoteDetailViewController.swift
//  Notes(pet)
//
//  Created by Danil Pestov on 22.09.2024.
//

import UIKit
import SnapKit

final class NoteDetailViewController: UIViewController {
    
    var note: Note?
    private var viewModel = NotesViewModel()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.boldSystemFont(ofSize: 24)
        textField.placeholder = Const.titleText
        return textField
    }()
    
    private let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = ColorResources.lightGray.cgColor
        textView.layer.cornerRadius = 8
        return textView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(Const.saveButtonTitle, for: .normal)
        button.setTitleColor(ColorResources.black, for: .normal)
        button.backgroundColor = ColorResources.darkGray
        button.layer.cornerRadius = 15
        button.makeAnimate(button)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorResources.white
        setupUI()
        setupLayout()
        setupAction()
        loadNoteData()
        setupHideKeyboardOnTap()
    }
}

private extension NoteDetailViewController {
    func setupAction() {
        saveButton.addTarget(self, action: #selector(saveNote), for: .touchUpInside)
    }
    
    func setupUI() {
        view.addSubview(titleTextField)
        view.addSubview(contentTextView)
        view.addSubview(dateLabel)
        view.addSubview(saveButton)
    }
    
    func setupLayout() {
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(view.frame.height / 20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(saveButton.snp.top).offset(-10)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.height.equalTo(view.frame.height / 20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(dateLabel.snp.top).offset(-10)
        }
    }
    
    private func loadNoteData() {
        guard let note = note else { return }
        titleTextField.text = note.title
        contentTextView.text = note.content
        
        if let createdDate = note.createdDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            dateFormatter.locale = Locale.current
            dateLabel.text = (dateFormatter.string(from: createdDate))
        } else {
            dateLabel.text = ""
        }
    }
    
    @objc private func saveNote() {
        guard let note = note,
              let updatedTitle = titleTextField.text,
              let updatedContent = contentTextView.text else { return }
        
        note.title = updatedTitle
        note.content = updatedContent
        viewModel.saveContext()
        navigationController?.popViewController(animated: true)
    }
}

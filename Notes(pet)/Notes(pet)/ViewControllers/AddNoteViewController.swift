//
//  AddNoteViewController.swift
//  Notes(pet)
//
//  Created by Danil Pestov on 21.09.2024.
//

import UIKit
import SnapKit

final class AddNoteViewController: UIViewController {
    
    var onNoteAdded: (() -> Void)?
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
    }
}

private extension AddNoteViewController {
    func setupAction() {
        saveButton.addTarget(self, action: #selector(saveNote), for: .touchUpInside)
    }
    
    func setupUI() {
        view.addSubview(titleTextField)
        view.addSubview(contentTextView)
        view.addSubview(saveButton)
    }
    
    func setupLayout() {
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(view.frame.height / 20)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.height.equalTo(view.frame.height / 20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(saveButton.snp.top).offset(-20)
        }
    }
    
    @objc func saveNote() {
        guard let title = titleTextField.text, !title.isEmpty,
              let content = contentTextView.text, !content.isEmpty else { return }
        
        let newNote = Note(context: viewModel.context)
        newNote.title = title
        newNote.content = content
        newNote.createdDate = Date()
        viewModel.saveContext()
        
        onNoteAdded?()
        navigationController?.popViewController(animated: true)
    }
}

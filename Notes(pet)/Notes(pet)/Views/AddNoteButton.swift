//
//  AddNoteButton.swift
//  Notes(pet)
//
//  Created by Danil Pestov on 18.09.2024.
//

import UIKit

final class AddNoteButton: UIButton {
    
    var addButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearence()
        makeSystem(self)
        setupAction()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}

private extension AddNoteButton {
    
    private func setupAppearence() {
        setImage(UIImage(named: "addNoteButtonImage"), for: .normal)
        backgroundColor = ColorResources.white
        
        layer.borderWidth = 1
        layer.borderColor = ColorResources.black.cgColor
        self.clipsToBounds = true
    }
    
    @objc func addButtonDidTapped() {
        addButtonTapped?()
    }
    
    private func setupAction() {
        addTarget(self, action: #selector(addButtonDidTapped), for: .touchUpInside)
    }
}

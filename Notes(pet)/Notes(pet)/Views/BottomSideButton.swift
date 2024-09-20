//
//  SideCustomButton.swift
//  Notes(pet)
//
//  Created by Danil Pestov on 20.09.2024.
//

import UIKit

enum SideButtonType {
    case sort
    case search
}

class BottomSideButton: UIButton {
    
    init(type: SideButtonType) {
        super.init(frame: .zero)
        makeAnimate(self)
        configureButton(for: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BottomSideButton {
    func configureButton(for type: SideButtonType) {
        switch type {
        case .sort:
            setImage(UIImage(named: "sortButtonImage"), for: .normal)
        case .search:
            setImage(UIImage(named: "searchButtonImage"), for: .normal)
        }
        
        contentHorizontalAlignment = .center
        makeAnimate(self)
    }
}

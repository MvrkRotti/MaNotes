//
//  UIViewController.swift
//  Notes(pet)
//
//  Created by Danil Pestov on 20.09.2024.
//

import UIKit
import SnapKit

extension UIViewController {
    func addNavigationBarSeparator(color: UIColor = ColorResources.darkGray, height: CGFloat = 1) {
        let separator = UIView()
        separator.backgroundColor = color
        
        view.addSubview(separator)
        
        separator.snp.makeConstraints { make in
            make.height.equalTo(height)
            make.left.right.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupHideKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

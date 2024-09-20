//
//  UIView.swift
//  Notes(pet)
//
//  Created by Danil Pestov on 19.09.2024.
//

import UIKit

extension UIButton {
    
    func makeAnimate(_ button: UIButton) {
        button.addTarget(self, action: #selector(handleIn), for: [
            .touchDown,
            .touchDragInside
        ])
        
        button.addTarget(self, action: #selector(handleOut), for: [
            .touchDragOutside,
            .touchUpInside,
            .touchUpOutside,
            .touchDragExit,
            .touchCancel
        ])
    }
    
    @objc func handleIn() {
        UIView.animate(withDuration: 0.5) { self.alpha = 0.8 }
    }
    
    @objc func handleOut() {
        UIView.animate(withDuration: 0.5) { self.alpha = 1 }
    }
    
    func setupView(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
}

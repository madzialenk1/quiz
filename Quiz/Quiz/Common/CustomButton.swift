// CustomButton.swift
// Quiz
//
// Created by Magda Pękacka on 03/10/2023.
//

import UIKit

class CustomButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setupButton()
        setTitle(title, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        setShadow()
        setTitleColor(.brown, for: .normal)
        backgroundColor = Colors.customYellow
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
        layer.cornerRadius = 20
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    private func setShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.5
        clipsToBounds = true
        layer.masksToBounds = false
    }
}


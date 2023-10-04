//
//  AnswerTableViewCell.swift
//  Quiz
//
//  Created by Magda Pękacka on 03/10/2023.
//

import Foundation
import SnapKit
import RxCocoa
import RxSwift

class AnswerTableViewCell: UITableViewCell {
    let answerButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = .clear
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blue.cgColor
        return button
    }()
    
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    var disposeBag = DisposeBag()
    
    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(answerButton)
        contentView.addSubview(answerLabel)
        answerButton.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        answerLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(answerButton.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
        }
    }
    
    func configure(order: Int, answerText: String, isSelected: Bool) {
        setupUI()
        answerButton.setTitle("\(order)", for: .normal)
        answerLabel.text = answerText
        answerButton.backgroundColor = isSelected ? .blue : .clear
        answerButton.setTitleColor(isSelected ? .white : .black, for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

extension Reactive where Base: AnswerTableViewCell {
    var answerButtonTapped: ControlEvent<Void> {
        return base.answerButton.rx.tap
    }
}

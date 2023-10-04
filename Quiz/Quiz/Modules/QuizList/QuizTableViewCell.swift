//
//  QuizTableViewCell.swift
//  Quiz
//
//  Created by Magda Pękacka on 01/10/2023.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher


class QuizTableViewCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private let quizImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(quizImageView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        
        quizImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(100)
        }
    }
    
    func configure(with quiz: Quiz, imageUrlString: String?) {
        setupUI()
        titleLabel.text = quiz.title
        
        if let imageUrlString = imageUrlString, let imageUrl = URL(string: imageUrlString) {
            loadImageFromURL(imageUrl)
        }
    }
    
    private func loadImageFromURL(_ url: URL) {
        quizImageView.kf.setImage(with: url)
    }
}

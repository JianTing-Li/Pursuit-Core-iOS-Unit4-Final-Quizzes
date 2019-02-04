//
//  QuizCell.swift
//  Quizzes
//
//  Created by Jian Ting Li on 2/1/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

protocol QuizCellDelegate: AnyObject {
    func buttonPressed(tag: Int)
}

class QuizCell: UICollectionViewCell {
    
    weak var delegate: QuizCellDelegate?
    
    lazy var optionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "more-filled"), for: .normal)
        button.addTarget(self, action: #selector(optionButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var quizTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Topic Title"
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        setupCellConstraints()
    }
    
    public func configureCellUI(quiz: Quiz, tag: Int) {
        quizTitleLabel.text = quiz.quizTitle
        optionButton.tag = tag
    }
    
    @objc func optionButtonPressed() {
        delegate?.buttonPressed(tag: optionButton.tag)
    }
}


extension QuizCell {
    private func setupCellConstraints() {
        setupQuizTitleLabel()
        setupOptionButton()
    }
    
    private func setupQuizTitleLabel() {

        addSubview(quizTitleLabel)
        quizTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        quizTitleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        quizTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        quizTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        quizTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
        
    }
    
    private func setupOptionButton() {
        addSubview(optionButton)
        optionButton.translatesAutoresizingMaskIntoConstraints = false
        optionButton.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        optionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
    }
}

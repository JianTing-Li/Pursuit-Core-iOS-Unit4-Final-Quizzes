//
//  SearchCollectionViewCell.swift
//  Quizzes
//
//  Created by Jian Ting Li on 2/1/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit


protocol SearchCellDelegate: AnyObject {
    func buttonPressed(tag: Int)
}

class SearchCell: UICollectionViewCell {
    
    weak var delegate: SearchCellDelegate?
    
    lazy var topicLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Topic Title"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var addToMyQuizzesButton: UIButton = {
        let button = UIButton()
        button.setTitle("➕", for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(40)
        button.addTarget(self, action: #selector(addToMyQuizzes), for: .touchUpInside)
        return button
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
        backgroundColor = UIColor.init(hexString: "#dfe6e9")
        setupCellConstraints()
    }
    
    public func configureCellUI(quiz: Quiz) {
        topicLabel.text = quiz.quizTitle
    }
    
    @objc private func addToMyQuizzes() {
        delegate?.buttonPressed(tag: addToMyQuizzesButton.tag)
    }
}

extension SearchCell {
    private func setupCellConstraints() {
        setupTopicLabel()
        setupAddToMyQuizzesButton()
    }
    
    private func setupTopicLabel() {
        addSubview(topicLabel)
        topicLabel.translatesAutoresizingMaskIntoConstraints = false
        topicLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        topicLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        topicLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        topicLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }
    
    private func setupAddToMyQuizzesButton() {
        addSubview(addToMyQuizzesButton)
        addToMyQuizzesButton.translatesAutoresizingMaskIntoConstraints = false
        addToMyQuizzesButton.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        addToMyQuizzesButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
    }
}

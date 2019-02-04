//
//  QuizDetailCell.swift
//  Quizzes
//
//  Created by Jian Ting Li on 2/4/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

// ToDO: Transition the whole Cell!!

protocol QuizDetailCellDelegate: AnyObject {
    func getQuizTitle(tag: Int) -> String
    func getQuizFact(tag: Int) -> String
}

class QuizDetailCell: UICollectionViewCell {
    
    weak var delegate: QuizDetailCellDelegate?
    
    lazy var flashCardButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Quiz Title / Fact", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(textTransition), for: .touchUpInside)
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
        backgroundColor = .clear
        setupCellConstraints()
    }
    
    private func setupCellConstraints() {
        addSubview(flashCardButton)
        flashCardButton.translatesAutoresizingMaskIntoConstraints = false
        flashCardButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        flashCardButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        flashCardButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        flashCardButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    public func configureCell(quizTitle: String, tag: Int) {
        flashCardButton.setTitle(quizTitle, for: .normal)
        flashCardButton.tag = tag
    }
    
    @objc private func textTransition() {
        let quizTitle = delegate?.getQuizFact(tag: flashCardButton.tag)
        let quizFact = delegate?.getQuizFact(tag: flashCardButton.tag)
        
        if flashCardButton.titleLabel?.text == quizTitle {
            UIView.transition(with: flashCardButton, duration: 2.0, options: [.transitionFlipFromRight], animations: {
                self.flashCardButton.setTitle((quizFact), for: .normal)
            })
        } else {
            UIView.transition(with: flashCardButton, duration: 2.0, options: [.transitionFlipFromLeft], animations: {
                self.flashCardButton.setTitle(quizTitle, for: .normal)
            })
        }
    }
}

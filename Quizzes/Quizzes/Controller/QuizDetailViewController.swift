//
//  QuizDetailViewController.swift
//  Quizzes
//
//  Created by Jian Ting Li on 2/1/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class QuizDetailViewController: UIViewController {
    
    let quizDetailView = QuizDetailView()
    var quiz: Quiz!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(quiz: Quiz) {
        super.init(nibName: nil, bundle: nil)
        self.quiz = quiz
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        self.view.addSubview(quizDetailView)
        quizDetailView.delegate = self
    }
}

extension QuizDetailViewController: QuizDetailViewDelegate {
    func getNumberOfFacts() -> Int {
        return quiz.facts.count
    }
    
    func setCollectionViewCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = quizDetailView.quizDetailCollectionView.dequeueReusableCell(withReuseIdentifier: "QuizDetailCell", for: indexPath) as? QuizDetailCell else { return UICollectionViewCell() }
        cell.configureCell(quizTitle: quiz.quizTitle, tag: indexPath.row)
        cell.delegate = self
        return cell
    }
}

extension QuizDetailViewController: QuizDetailCellDelegate {
    func animationButtonPressed(tag: Int) {
        let quizTitle = quiz.quizTitle
        let quizFact = quiz.facts[tag]
//        if cat.imageView?.image == UIImage(named: "cat") {
//            UIView.transition(with: cat, duration: 2.0, options: [.transitionFlipFromRight], animations: {
//                self.cat.setImage(UIImage(named: "dog"), for: .normal)
//            })
//        } else {
//            UIView.transition(with: cat, duration: 2.0, options: [.transitionFlipFromLeft], animations: {
//                self.cat.setImage(UIImage(named: "cat"), for: .normal)
//            })
//        }
        
    }
}

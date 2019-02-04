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
    func getQuizTitle(tag: Int) -> String {
        return quiz.quizTitle
    }
    
    func getQuizFact(tag: Int) -> String {
        return quiz.facts[tag]
    }
    

}

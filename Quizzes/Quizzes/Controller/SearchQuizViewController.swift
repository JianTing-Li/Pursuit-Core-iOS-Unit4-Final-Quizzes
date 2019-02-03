//
//  SearchQuizViewController.swift
//  Quizzes
//
//  Created by Jian Ting Li on 2/1/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class SearchQuizViewController: UIViewController {
    
    let searchQuizView = SearchQuizView()
    
    var onlineQuizzes = [Quiz]() {
        didSet {
            DispatchQueue.main.async {
                self.searchQuizView.searchQuizesCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(searchQuizView)
        searchQuizView.deleagte = self
        fetchQuizesOnline()
    }
    
    private func fetchQuizesOnline() {
        QuizAPIClient.getAllOnlineQuizzes { (appError, quizzes) in
            if let appError = appError {
                print(appError.errorMessage())
                self.showAlert(title: "", message: appError.errorMessage())
            } else if let quizzes = quizzes {
                self.onlineQuizzes = quizzes
            }
        }
    }
}

extension SearchQuizViewController: SearchQuizViewDelegate, SearchCellDelegate {
    
    func setupNumberOfItemsInCollectionView() -> Int {
        return onlineQuizzes.count
    }
    
    func setupCollectionViewCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = searchQuizView.searchQuizesCollectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as? SearchCell else { return UICollectionViewCell() }
        cell.delegate = self
        let currentQuiz = onlineQuizzes[indexPath.row]
        cell.addToMyQuizzesButton.tag = indexPath.row
        cell.configureCellUI(quiz: currentQuiz)
        return cell
    }
    
    func buttonPressed(tag: Int) {
        let quizGoingToAdd = onlineQuizzes[tag]
        // * add quiz here
        showAlert(title: "\"\(quizGoingToAdd.quizTitle)\" was added to your Quiz Collection", message: nil)
    }
}

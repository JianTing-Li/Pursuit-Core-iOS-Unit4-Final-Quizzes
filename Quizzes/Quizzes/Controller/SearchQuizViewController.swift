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
    
    var currentUser: User?
    var userIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(searchQuizView)
        searchQuizView.deleagte = self
        initialSetup()
    }
    
    private func initialSetup() {
        if getCurrentUser() {
            fetchQuizesOnline()
        }
    }
    
    private func fetchQuizesOnline() {
        QuizAPIClient.getAllOnlineQuizzes { (appError, quizzes) in
            if let appError = appError {
                print(appError.errorMessage())
                self.showAlert(title: "", message: appError.errorMessage())
            } else if let quizzes = quizzes {
                self.onlineQuizzes = quizzes.sorted { $0.quizTitle < $1.quizTitle }
            }
        }
    }
    
    private func getCurrentUser() -> Bool {
        if let lastUserName = UserDefaults.standard.object(forKey: UserDefaultsKeys.lastUserName) as? String {
            let index = UserDataManager.fetchAllUsers().firstIndex { $0.username == lastUserName }
            if let _ = index {
                self.currentUser = UserDataManager.fetchAllUsers()[index!]
                self.userIndex = index
                return true
            }
        }
        return false
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
        currentUser?.quizzes.append(quizGoingToAdd)
        print("The user has \(currentUser?.quizzes.count) quizzes")
        guard let updatedUser = currentUser, let userIndex = userIndex else {
            print("currentUser / userIndex is nil")
            showAlert(title: "Fail to add Quiz ☹️", message: nil)
            return
        }
        UserDataManager.updateUserInfo(updatedUser: updatedUser, atIndex: userIndex)
        showAlert(title: "\"\(quizGoingToAdd.quizTitle)\" was added to your Quiz Collection", message: nil)
    }
}

//
//  QuizViewController.swift
//  Quizzes
//
//  Created by Jian Ting Li on 2/1/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet weak var myQuizzesCollectionView: UICollectionView!
    
    var currentUser: User?
    var userIndex: Int?
    var userQuizzes = [Quiz]() {
        didSet {
            DispatchQueue.main.async {
                self.myQuizzesCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myQuizzesCollectionView.dataSource = self
        myQuizzesCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        initialSetup()
    }
    
    private func initialSetup() {
        if getCurrentUser() {
            self.userQuizzes = currentUser!.quizzes
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

extension QuizViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userQuizzes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = myQuizzesCollectionView.dequeueReusableCell(withReuseIdentifier: "QuizCell", for: indexPath) as? QuizCell else { return UICollectionViewCell() }
        cell.delegate = self
        let quiz = userQuizzes[indexPath.row]
        cell.configureCellUI(quiz: quiz, tag: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 272*1.2, height: 360*1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentQuiz = userQuizzes[indexPath.row]
        let destinationVC = QuizDetailViewController(quiz: currentQuiz)
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

extension QuizViewController: QuizCellDelegate {
    func buttonPressed(tag: Int) {
        currentUser?.quizzes.remove(at: tag)
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            guard let currentUser = self.currentUser, let index = self.userIndex else {
                print("user / index is nil")
                self.showAlert(title: "User is not login", message: nil)
                return
            }
            UserDataManager.updateUserInfo(updatedUser: currentUser, atIndex: index)
            self.userQuizzes = currentUser.quizzes
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
    }
}

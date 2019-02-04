//
//  CreateQuizViewController.swift
//  Quizzes
//
//  Created by Jian Ting Li on 2/1/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class CreateQuizViewController: UIViewController {
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var quizTitleTextView: UITextView!
    @IBOutlet weak var fact1TextView: UITextView!
    @IBOutlet weak var fact2TextView: UITextView!
    @IBOutlet weak var createQuizButton: UIBarButtonItem!
    
    var currentUser: User?
    var userIndex: Int?
    
    private let quizTitlePlaceholder = "Quiz Title"
    private let fact1Placeholder = "Fact 1"
    private let fact2Placeholder = "Fact 2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkUserLogin()
    }
    
    private func checkUserLogin() {
        createQuizButton.isEnabled = getCurrentUser() ? true : false
        if !createQuizButton.isEnabled { showAlert(title: "Not Login", message: "Please Login to create quiz") }
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
    
    private func setupTextViews() {
        quizTitleTextView.delegate = self
        fact1TextView.delegate = self
        fact2TextView.delegate = self
        quizTitleTextView.text = quizTitlePlaceholder
        quizTitleTextView.textColor = .lightGray
        fact1TextView.text = fact1Placeholder
        fact1TextView.textColor = .lightGray
        fact2TextView.text = fact2Placeholder
        fact2TextView.textColor = .lightGray
        
    }
    
    @IBAction func tapAnywhere(_ sender: UITapGestureRecognizer) {
        quizTitleTextView.resignFirstResponder()
        fact1TextView.resignFirstResponder()
        fact2TextView.resignFirstResponder()
    }
    
    @IBAction func createQuiz(_ sender: UIBarButtonItem) {
        guard let quizTitle = quizTitleTextView.text,
            let fact1 = fact1TextView.text,
            let fact2 = fact2TextView.text,
            quizTitle != quizTitlePlaceholder,
            fact1 != fact1Placeholder,
            fact2 != fact1Placeholder else {
                showAlert(title: "❌", message: "Make sure you enter a title and 2 facts")
                return
        }
        let newQuiz = Quiz.init(facts: [fact1, fact2], id: UUID().uuidString, quizTitle: quizTitle)
        currentUser?.quizzes.append(newQuiz)
        UserDataManager.updateUserInfo(updatedUser: currentUser!, atIndex: userIndex!)
        showAlert(title: "Success", message: "\"\(quizTitle)\" added to your quizzes")
    }
    
}

extension CreateQuizViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == quizTitleTextView, quizTitleTextView.text == quizTitlePlaceholder {
            textView.text = ""
            textView.textColor = .black
            return
        }
        
        if textView == fact1TextView, fact1TextView.text == fact1Placeholder {
            textView.text = ""
            textView.textColor = .black
            return
        }

        if textView == fact2TextView, fact2TextView.text == fact2Placeholder {
            textView.text = ""
            textView.textColor = .black
            return
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            if textView == quizTitleTextView {
                textView.text = quizTitlePlaceholder
                textView.textColor = .lightGray
            }
            if textView == fact1TextView {
                textView.text = fact1Placeholder
                textView.textColor = .lightGray
            }
            if textView == fact2TextView {
                textView.text = fact2Placeholder
                textView.textColor = .lightGray
            }
        }
    }
}

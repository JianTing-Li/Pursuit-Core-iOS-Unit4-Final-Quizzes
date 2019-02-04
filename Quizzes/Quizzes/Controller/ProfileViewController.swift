//
//  ProfileViewController.swift
//  Quizzes
//
//  Created by Jian Ting Li on 2/1/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    
    private var imagePickerVC: UIImagePickerController!
    
    var allUsers = [User]()
    var currentUser: User? {
        didSet {
            profileNameLabel.text = "@\(currentUser!.username)"
            if let imageData = currentUser?.photoData {
                profileImage.image = UIImage(data: imageData)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    private func initialSetup() {
        setupImagePickerViewController()
        checkUserDefaults()
        //profileImage.layer.cornerRadius = profileImage.bounds.width / 2
    }
    
    private func checkUserDefaults() {
        if let lastUserName = UserDefaults.standard.object(forKey: UserDefaultsKeys.lastUserName) as? String {
            self.allUsers = UserDataManager.fetchAllUsers()
            let index = allUsers.firstIndex { $0.username == lastUserName }
            if let _ = index {
                self.currentUser = allUsers[index!]
            } else {
                showAlert(title: "Can't find last user in directory", message: nil)
                print("Can't find user in directory..creating a new user")
            }
        } else {
//            UserDataManager.saveToDocumentDirectory() // to clears data
            createNewUser()
        }
    }
    
    private func createNewUser() {
        let alertController = UIAlertController(title: "Please Enter Your Username", message: "No spaces or special characters", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { alert in
            // need to guard against special chars & spaces
            guard let newUserName = alertController.textFields?.first?.text else {
                print("User entered nothing for userName")
                self.showAlert(title: "Profile needed", message: "Please enter a username")
                return
            }
            
            let index = self.allUsers.firstIndex { $0.username == newUserName }
            guard index == nil else {
                print("Username already exist")
                self.showAlert(title: "Username already exist", message: "Please enter another username")
                return
            }
            
            let newUser = User.init(username: newUserName, userID: UUID().uuidString, photoData: nil, quizzes: [Quiz]())
            UserDataManager.addNewUser(newUser: newUser)
            self.currentUser = newUser
            self.allUsers = UserDataManager.fetchAllUsers()
            UserDefaults.standard.set(newUserName, forKey: UserDefaultsKeys.lastUserName)
        }
        
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Enter Username"
            textfield.textAlignment = .center
        }
        alertController.addAction(cancelAction)
        alertController.addAction(submitAction)
        
        present(alertController, animated: true)
    }
    
    private func showImagePickerVC() {
        present(imagePickerVC, animated: true, completion: nil)
    }
    
    private func setupImagePickerViewController() {
        imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
    }
    
    @IBAction func changeProfilePic(_ sender: UIButton) {
        imagePickerVC.sourceType = .photoLibrary
        showImagePickerVC()
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.image = image
            updateUserPhoto(image: image)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func updateUserPhoto(image: UIImage) {
        guard let currentUser = currentUser else { return }
        let updatedUser = User.init(username: currentUser.username, userID: currentUser.userID, photoData: image.jpegData(compressionQuality: 0.5), quizzes: currentUser.quizzes)
        
        let index = allUsers.firstIndex { $0.username == updatedUser.username }
        if let _ = index {
            UserDataManager.updateUserInfo(updatedUser: updatedUser, atIndex: index!)
            UserDataManager.saveToDocumentDirectory()
            self.currentUser = updatedUser
            self.allUsers = UserDataManager.fetchAllUsers()
        } else {
            print("Update User Failed: Can't get index")
            showAlert(title: "Update User Failed", message: "Can't find user in directory")
        }
    }
}

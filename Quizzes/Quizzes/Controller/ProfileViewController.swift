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
        allUsers = ProfileDataManager.fetchAllUsers()
        setupImagePickerViewController()
        //profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        checkUserDefaults()
    }
    
    private func checkUserDefaults() {
        if let lastUserName = UserDefaults.standard.object(forKey: UserDefaultsKeys.lastUserName) as? String {
            let optionalIndex = allUsers.firstIndex { $0.username == lastUserName }
            guard let index = optionalIndex else {
                createNewUser()
                return
            }
            self.currentUser = allUsers[index]
        } else {
            createNewUser()
        }
    }
    
    private func createNewUser() {
        let alertController = UIAlertController(title: "Please Enter Your Username", message: "No spaces or special characters", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { alert in
            // need to guard against special chars & spaces
            guard let newUserName = alertController.textFields?.first?.text else {
                print("alertController is nil")
                //show alert to user
                return
            }
            let newUser = User.init(username: newUserName, photoData: nil)
            ProfileDataManager.addNewUser(newUser: newUser)
            self.currentUser = newUser
            self.allUsers = ProfileDataManager.fetchAllUsers()
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
            updateUserPhoto(user: currentUser, image: image)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func updateUserPhoto(user: User?, image: UIImage) {
        guard let currentUser = user else { return }
        let updatedUser = User.init(username: (currentUser.username), photoData: image.jpegData(compressionQuality: 0.5))
        let index = ProfileDataManager.fetchAllUsers().firstIndex { $0.username == currentUser.username }
        if let _ = index {
            ProfileDataManager.updateUserInfo(updatedUser: updatedUser, atIndex: index!)
            ProfileDataManager.saveToDocumentDirectory()
            self.currentUser = updatedUser
            self.allUsers = ProfileDataManager.fetchAllUsers()
        }
    }
}

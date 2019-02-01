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
    
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
    }
    
    private func checkUserDefaults() {
        if let user = UserDefaults.standard.object(forKey: UserDefaultsKeys.currentUserName) as? String {
            
        } else {
            // UserDefaults.standard.set(categoryName, forKey: UserDefaultsKeys.defaultCategory)
        }
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
            //update model here
        }
        dismiss(animated: true, completion: nil)
    }
}

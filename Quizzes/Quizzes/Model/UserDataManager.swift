//
//  UserDataManager.swift
//  Quizzes
//
//  Created by Jian Ting Li on 2/1/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

final class UserDataManager {
    private init() {}

    private static let filename = "UserList.plist"
    private static var allUsers = [User]()
    
    public static func fetchAllUsers() -> [User] {
        let path = DataPersistenceManager.filepathToDocumentsDiretory(filename: filename).path
        
        if FileManager.default.fileExists(atPath: path) {
            if let data = FileManager.default.contents(atPath: path) {
                do {
                    allUsers = try PropertyListDecoder().decode([User].self, from: data)
                } catch {
                    print(AppError.propertyListDecodingError(error).errorMessage())
                }
            } else {
                print("Data is nil")
            }
        } else {
            print("\(filename) doesn't exist")
        }
        return allUsers
    }

    public static func saveToDocumentDirectory() {
        let path = DataPersistenceManager.filepathToDocumentsDiretory(filename: filename)
        do {
            let data = try PropertyListEncoder().encode(allUsers)
            try data.write(to: path, options: .atomic)
        } catch {
            print(AppError.propertyListEncodingError(error).errorMessage())
        }
    }
    
    public static func addNewUser(newUser: User) {
        allUsers.append(newUser)
        saveToDocumentDirectory()
    }

    public static func deleteUser(user: User, atIndex index: Int) {
        allUsers.remove(at: index)
        saveToDocumentDirectory()
    }

    public static func updateUserInfo(updatedUser: User, atIndex index: Int) {
        allUsers[index] = updatedUser
        saveToDocumentDirectory()
    }
}

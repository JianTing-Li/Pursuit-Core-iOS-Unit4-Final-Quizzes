//
//  User.swift
//  Quizzes
//
//  Created by Jian Ting Li on 2/1/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct User: Codable {
    let username: String
    let photoData: Data?
    var quizes: [Quiz]
}

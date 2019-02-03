//
//  Quiz.swift
//  Quizzes
//
//  Created by Jian Ting Li on 2/1/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct Quiz: Codable {
    let facts: [String]
    let id: String
    let quizTitle: String
}

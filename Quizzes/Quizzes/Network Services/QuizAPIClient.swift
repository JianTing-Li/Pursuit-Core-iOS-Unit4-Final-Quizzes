//
//  QuizAPIClient.swift
//  Quizzes
//
//  Created by Jian Ting Li on 2/1/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

final class QuizAPIClient {
    public static func getAllOnlineQuizzes(completionHandler: @escaping (AppError?, [Quiz]?) -> Void) {
        let endpointUrlString = "https://quizzes-9ff59.firebaseio.com/.json"
        
        guard let url = URL(string: endpointUrlString) else {
            completionHandler(AppError.badURL(endpointUrlString), nil)
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(AppError.networkError(error), nil)
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -999
                    completionHandler(AppError.badStatusCode(statusCode.description), nil)
                    return
            }
            if let data = data {
                do {
                    let quizzes = try JSONDecoder().decode([Quiz].self, from: data)
                    completionHandler(nil, quizzes)
                } catch {
                    completionHandler(AppError.jsonDecodingError(error), nil)
                }
            }
        }
        task.resume()
    }
}

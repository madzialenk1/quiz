//
//  QuizService.swift
//  Quiz
//
//  Created by Magda Pękacka on 09/11/2023.
//

import Foundation
import RxSwift

protocol NetworkServiceProtocol {
    func fetchQuizData() -> Single<QuizList>
}

class QuizService: NetworkServiceProtocol {
    func fetchQuizData() -> Single<QuizList> {
        guard let apiUrl = URL(string: Constants.listQuizUrl) else {
            return .error(NetworkError.invalidURL)
        }
        
        return URLSession.shared.rx.data(request: URLRequest(url: apiUrl))
            .map { data -> QuizList in
                let decoder = JSONDecoder()
                do {
                    let quizList = try decoder.decode(QuizList.self, from: data)
                    return quizList
                } catch {
                    throw NetworkError.decodingError(error)
                }
            }
            .asSingle()
    }
}

enum NetworkError: Error {
    case invalidURL
    case decodingError(Error)
}


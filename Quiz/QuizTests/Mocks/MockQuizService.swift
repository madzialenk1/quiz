//
//  MockQuizService.swift
//  QuizTests
//
//  Created by Magda Pękacka on 09/11/2023.
//

import Foundation
import RxSwift

@testable import Quiz

class MockQuizService: NetworkServiceProtocol {
    let result: Swift.Result<QuizList, Error>
    
    init(result: Swift.Result<QuizList, Error>) {
        self.result = result
    }
    
    func fetchQuizData() -> Single<QuizList> {
        return Single.create { single in
            switch self.result {
            case .success(let quizList):
                single(.success(quizList))
            case .failure(let error):
                single(.failure(MockError.mockError))
            }
            return Disposables.create()
        }
    }
}

enum MockError: Error {
    case mockError
}

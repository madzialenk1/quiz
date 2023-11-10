//
//  QuizListViewModel.swift
//  Quiz
//
//  Created by Magda Pękacka on 01/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

class QuizListViewModel {
    let quizData = BehaviorSubject<QuizList?>(value: nil)
    
    private let disposeBag = DisposeBag()
    private let quizService: NetworkServiceProtocol
    
    init(quizService: NetworkServiceProtocol) {
        self.quizService = quizService
        fetchQuizData()
    }
    
    private func fetchQuizData() {
        quizService.fetchQuizData()
            .subscribe(onSuccess: { [weak self] quizList in
                self?.quizData.onNext(quizList)
            }, onFailure: { [weak self] error in
                print("Error fetching quiz data: \(error)")
                self?.quizData.onError(error)
            })
            .disposed(by: disposeBag)
    }
}

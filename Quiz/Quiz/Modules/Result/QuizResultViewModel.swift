//
//  QuizResultViewModel.swift
//  Quiz
//
//  Created by Magda Pękacka on 03/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

class QuizResultViewModel {
    let resultInPercent = BehaviorRelay<Int>(value: 0)
    
    private let disposeBag = DisposeBag()
    
    init(selectedAnswers: [Int: AnswerQuestion], questionsCount: Int) {
        countResult(selectedAnswers: selectedAnswers, questionsCount: questionsCount)
    }
    
    private func countResult(selectedAnswers: [Int: AnswerQuestion], questionsCount: Int) {
        let correctAnswersCount = selectedAnswers.values.reduce(0) { (result, answer) in
            return result + (answer.isCorrect ? 1 : 0)
        }
        
        let percentCorrect = Int((Double(correctAnswersCount) / Double(questionsCount)) * 100)
        resultInPercent.accept(percentCorrect)
    }
}

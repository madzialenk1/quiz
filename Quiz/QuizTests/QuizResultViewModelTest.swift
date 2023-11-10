//
//  QuizResultViewModelTest.swift
//  QuizTests
//
//  Created by Magda Pękacka on 08/11/2023.
//

import Foundation
import XCTest

@testable import Quiz

class QuizResultViewModelTests: XCTestCase {
    
    func testCountResultForTwoCorrectAnswers() {
        
        let selectedAnswers: [Int: AnswerQuestion] = [
            1: AnswerQuestion(selectedOption: 1, isCorrect: true),
            2: AnswerQuestion(selectedOption: 2, isCorrect: true),
        ]
        
        let viewModel = QuizResultViewModel(selectedAnswers: selectedAnswers, questionsCount: 5)
        
        XCTAssertEqual(viewModel.resultInPercent.value, String(format: "result_percent".localized(), 40))
    }
    
    func testCountResultForZeroCorrectAnswers() {
        
        let selectedAnswers: [Int: AnswerQuestion] = [
            1: AnswerQuestion(selectedOption: 1, isCorrect: false),
        ]
        
        let viewModel = QuizResultViewModel(selectedAnswers: selectedAnswers, questionsCount: 10)
        
        XCTAssertEqual(viewModel.resultInPercent.value, String(format: "result_percent".localized(), 0))
    }
    
    func testCountResultForAllCorrectAnswers() {
        
        let selectedAnswers: [Int: AnswerQuestion] = [
            1: AnswerQuestion(selectedOption: 1, isCorrect: true),
        ]
        
        let viewModel = QuizResultViewModel(selectedAnswers: selectedAnswers, questionsCount: 1)
        
        XCTAssertEqual(viewModel.resultInPercent.value, String(format: "result_percent".localized(), 100))
    }
}


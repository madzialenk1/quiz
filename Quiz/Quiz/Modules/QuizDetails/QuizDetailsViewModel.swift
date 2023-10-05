//
//  QuizDetailsViewModel.swift
//  Quiz
//
//  Created by Magda Pękacka on 02/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

class QuizDetailsViewModel {
    let quizData = BehaviorRelay<QuizDetails?>(value: nil)
    let currentQuestionIndex = BehaviorRelay<Int>(value: 0)
    let selectedAnswersRelay = BehaviorRelay<[Int: AnswerQuestion]>(value: [:])
    
    private let disposeBag = DisposeBag()
    
    init(quizId: Int) {
        fetchQuizData(with: quizId)
    }
    
    func moveToNextQuestion(isNext: Bool) {
        guard let quizData = quizData.value else { return }
        
        let newIndex = isNext ? min(currentQuestionIndex.value + 1, (quizData.questions?.count ?? 0) - 1) :
        max(currentQuestionIndex.value - 1, 0)
        
        currentQuestionIndex.accept(newIndex)
    }
    
    private func fetchQuizData(with id: Int) {
        let apiUrl = URL(string: "https://quiz.o2.pl/api/v1/quiz/\(id)/0")!
        
        let dataObservable = URLSession.shared.rx.data(request: URLRequest(url: apiUrl))
        
        dataObservable
            .flatMap { data -> Observable<QuizDetails> in
                let decoder = JSONDecoder()
                do {
                    let quizList = try decoder.decode(QuizDetails.self, from: data)
                    return Observable.just(quizList)
                } catch {
                    return Observable.error(error)
                }
            }
            .subscribe(onNext: { [weak self] quizList in
                self?.quizData.accept(quizList)
            }, onError: { [weak self] error in
                print("Error fetching quiz data: \(error)")
                self?.quizData.accept(nil)
            })
            .disposed(by: disposeBag)
    }
    
    func getCurrentAnswers() -> [AnswerCellModel] {
        guard let questions = quizData.value?.questions,
              currentQuestionIndex.value >= 0, currentQuestionIndex.value < questions.count else {
            return []
        }
        
        return questions[currentQuestionIndex.value].answers.map { answer in
            let isSelected = selectedAnswersRelay.value[currentQuestionIndex.value]?.selectedOption == answer.order
            return AnswerCellModel(answer: answer, isSelected: isSelected)
        }
    }
    
    func selectAnswer(questionId: Int, selectedOption: Int, isCorrect: Bool) {
        let selectedAnswer = AnswerQuestion(selectedOption: selectedOption, isCorrect: isCorrect)
        selectedAnswersRelay.accept(selectedAnswersRelay.value.merging([questionId: selectedAnswer]) { (_, new) in new })
    }
    
    func getCurrentQuestionText() -> String? {
        guard let questions = quizData.value?.questions,
              currentQuestionIndex.value >= 0, currentQuestionIndex.value < questions.count else {
            return nil
        }
        
        return questions[currentQuestionIndex.value].text
    }
}

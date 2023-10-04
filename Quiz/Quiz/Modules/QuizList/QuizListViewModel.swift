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
    
    init() {
        fetchQuizData()
    }
    
    private func fetchQuizData() {
        guard let apiUrl = URL(string: Constants.listQuizUrl) else { return }
        
        let dataObservable = URLSession.shared.rx.data(request: URLRequest(url: apiUrl))
        
        dataObservable
            .map { data -> QuizList in
                let decoder = JSONDecoder()
                do {
                    let quizList = try decoder.decode(QuizList.self, from: data)
                    return quizList
                } catch {
                    print("Error decoding data: \(error)")
                    return QuizList(count: 0, items: [])
                }
            }
            .subscribe(onNext: { [weak self] quizList in
                self?.quizData.onNext(quizList)
            }, onError: { [weak self] error in
                print("Error fetching quiz data: \(error)")
                // TODO: add error screen
            })
            .disposed(by: disposeBag)
    }
}

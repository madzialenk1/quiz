//
//  QuizListViewModelTest.swift
//  QuizTests
//
//  Created by Magda Pękacka on 09/11/2023.
//

import Foundation
import XCTest
import RxSwift
import RxTest

@testable import Quiz

class QuizListViewModelTests: XCTestCase {
    
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        scheduler = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testFetchQuizDataSuccess() {
        let quizListData = QuizList(count: 0, items: [])
        let mockQuizService = MockQuizService(result: .success(quizListData))
        let viewModel = QuizListViewModel(quizService: mockQuizService)
        let observer = scheduler.createObserver(QuizList.self)
        
        viewModel.quizData
            .compactMap({$0})
            .subscribe(observer)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        XCTAssertEqual(observer.events, [.next(0, quizListData)])
    }
}

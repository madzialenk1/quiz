//
//  QuizCoordinator.swift
//  Quiz
//
//  Created by Magda Pękacka on 02/10/2023.
//

import Foundation
import UIKit

class QuizCoordinator: ResultCoordinatorDelegate, QuizDetailsCoordinatorDelegate, QuizListCoordinatorDelegate {
    var navigationController: UINavigationController?
    
    func start() {
        let viewModel = QuizListViewModel()
        let viewController = QuizListViewController(viewModel: viewModel, quizCoordinator: self)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func openQuizDetails(with id: Int) {
        let viewModel = QuizDetailsViewModel(quizId: id)
        let viewController = QuizViewController(viewModel: viewModel, coordinator: self as QuizDetailsCoordinatorDelegate)
        navigationController?.navigationBar.isHidden = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func goToResultScreen(selectedAnswers: [Int: AnswerQuestion], questionsCount: Int) {
        let viewModel = QuizResultViewModel(selectedAnswers: selectedAnswers, questionsCount: questionsCount)
        let viewController = ResultViewController(viewModel: viewModel, coordinator: self as ResultCoordinatorDelegate)
        navigationController?.navigationBar.isHidden = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func startQuizAgain() {
        navigationController?.popViewController(animated: true)
    }
    
    func navigateToListOfQuizzes() {
        navigationController?.popToRootViewController(animated: true)
    }
}

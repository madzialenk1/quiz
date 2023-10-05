//
//  QuizListViewController.swift
//  Quiz
//
//  Created by Magda Pękacka on 01/10/2023.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

protocol QuizListCoordinatorDelegate: AnyObject {
    func openQuizDetails(with id: Int)
}

class QuizListViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(QuizTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 200
        return tableView
    }()
    
    private let disposeBag = DisposeBag()
    private let viewModel: QuizListViewModel
    private var quizCoordinator: QuizListCoordinatorDelegate?
    
    init(viewModel: QuizListViewModel, quizCoordinator: QuizListCoordinatorDelegate) {
        self.viewModel = viewModel
        self.quizCoordinator = quizCoordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "nav_title".localized()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.quizData
            .compactMap { $0?.items }
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: QuizTableViewCell.self)) { model, quiz, cell in
                let modifiedUrlString = quiz.mainPhoto.url.modifyImageUrl(width: quiz.mainPhoto.width, height: quiz.mainPhoto.height)
                cell.configure(with: quiz, imageUrlString: modifiedUrlString)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Quiz.self)
            .subscribe(onNext: { [weak self] quiz in
                if let indexPath = self?.tableView.indexPathForSelectedRow {
                    self?.tableView.deselectRow(at: indexPath, animated: true)
                }
                self?.quizCoordinator?.openQuizDetails(with: quiz.id)
            })
            .disposed(by: disposeBag)
        
    }
}

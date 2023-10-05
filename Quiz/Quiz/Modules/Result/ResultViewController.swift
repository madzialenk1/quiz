//
//  ResultViewController.swift
//  Quiz
//
//  Created by Magda Pękacka on 03/10/2023.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

protocol ResultCoordinatorDelegate: AnyObject {
    func startQuizAgain()
    func navigateToListOfQuizzes()
}

class ResultViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "good_job_label".localized()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 27, weight: .bold)
        return label
    }()
    
    private let solveAgainButton = CustomButton(title: "solve_again_button".localized())
    
    private let goToQuizzesButton = CustomButton(title: "go_to_list_button".localized())
    
    private let disposeBag = DisposeBag()
    private let viewModel: QuizResultViewModel
    private weak var coordinator: ResultCoordinatorDelegate?
    
    init(viewModel: QuizResultViewModel, coordinator: ResultCoordinatorDelegate) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        setupConstraints()
        setupRx()
    }
    
    private func setupSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(resultLabel)
        view.addSubview(solveAgainButton)
        view.addSubview(goToQuizzesButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.centerX.equalToSuperview()
        }
        
        resultLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        solveAgainButton.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(20)
            $0.height.equalTo(40)
            $0.bottom.equalTo(goToQuizzesButton.snp.top).offset(-10)
        }
        
        goToQuizzesButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
            $0.trailing.leading.equalToSuperview().inset(20)
        }
    }
    
    private func setupRx() {
        viewModel.resultInPercent
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
        
        solveAgainButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.startQuizAgain()
            })
            .disposed(by: disposeBag)
        
        goToQuizzesButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.navigateToListOfQuizzes()
            })
            .disposed(by: disposeBag)
    }
}

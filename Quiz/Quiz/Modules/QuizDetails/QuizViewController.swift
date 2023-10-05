//
//  QuizViewController.swift
//  Quiz
//
//  Created by Magda Pękacka on 02/10/2023.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

protocol QuizDetailsCoordinatorDelegate: AnyObject {
    func goToResultScreen(selectedAnswers: [Int: AnswerQuestion], questionsCount: Int)
}

class QuizViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private let progressBar: UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.tintColor = .blue
        progressBar.progressTintColor = Colors.customYellow
        return progressBar
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let quizNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let nextButton = CustomButton(title: "next_button".localized())
    
    private let previousButton = CustomButton(title: "previous_button".localized())
    
    private let finishButton = CustomButton(title: "finish_quiz_button".localized())
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let viewModel: QuizDetailsViewModel
    private let disposeBag = DisposeBag()
    
    private weak var coordinator: QuizDetailsCoordinatorDelegate?
    
    init(viewModel: QuizDetailsViewModel, coordinator: QuizDetailsCoordinatorDelegate) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubviews()
        bindViewModel()
        setupConstraints()
        configureTableView()
        setupRxButtons()
    }
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(progressBar)
        scrollView.addSubview(photoImageView)
        scrollView.addSubview(questionLabel)
        scrollView.addSubview(quizNameLabel)
        scrollView.addSubview(tableView)
        scrollView.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(previousButton)
        buttonStackView.addArrangedSubview(finishButton)
        buttonStackView.addArrangedSubview(nextButton)
    }
    
    private func configureTableView() {
        tableView.register(AnswerTableViewCell.self, forCellReuseIdentifier: "answer_cell_identifier".localized())
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func setupConstraints() {
        quizNameLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(scrollView.snp.top).offset(20)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        progressBar.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(quizNameLabel.snp.bottom).offset(20)
            $0.height.equalTo(5)
        }
        
        photoImageView.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(photoImageView.snp.bottom).offset(15)
            $0.trailing.leading.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(progressBar.snp.bottom).offset(20)
            $0.trailing.leading.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        finishButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        previousButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(150)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(scrollView.snp.bottom)
        }
    }
    
    private func updateUI(){
        if let questionText = viewModel.getCurrentQuestionText() {
            DispatchQueue.main.async { [weak self] in
                self?.questionLabel.text = questionText
            }
        }
    }
    
    private func bindViewModel() {
        viewModel.quizData
            .bind { [weak self] quizDetails in
                guard let quizDetails = quizDetails else { return }
                DispatchQueue.main.async {[weak self] in
                    self?.quizNameLabel.text = quizDetails.title
                    if let modifiedUrl = quizDetails.mainPhoto.url.modifyImageUrl(width: quizDetails.mainPhoto.width, height: quizDetails.mainPhoto.height), let imageUrl = URL(string: modifiedUrl) {
                        self?.loadImageFromURL(imageUrl)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.currentQuestionIndex, viewModel.quizData, viewModel.selectedAnswersRelay)
            .map { [weak self] index, quizData, selectedAnswers in
                self?.updateUI()
                return self?.viewModel.getCurrentAnswers() ?? [AnswerCellModel]()
            }
            .bind(to: tableView.rx.items(cellIdentifier: "answer_cell_identifier".localized(), cellType: AnswerTableViewCell.self)) {
                model, quizAnswer, cell in
                cell.configure(order: quizAnswer.answer.order, answerText: quizAnswer.answer.text, isSelected: quizAnswer.isSelected)
                
                cell.rx.answerButtonTapped
                    .map { quizAnswer }
                    .bind(onNext: { [weak self] quizAnswer in
                        guard let questionId = self?.viewModel.currentQuestionIndex.value else {
                            return
                        }
                        self?.viewModel.selectAnswer(questionId: questionId, selectedOption: quizAnswer.answer.order, isCorrect: (quizAnswer.answer.isCorrect ?? 0) == 0 ? false : true)
                    }).disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        viewModel.currentQuestionIndex
            .subscribe(onNext: {[weak self] index in
                self?.previousButton.isHidden = index == 0
                guard let questionsCount = self?.viewModel.quizData.value?.questions?.count else { return }
                self?.nextButton.isHidden = index == questionsCount - 1
                self?.progressBar.progress = Float(index) / Float(questionsCount - 1)
            }).disposed(by: disposeBag)
    }
    
    private func setupRxButtons() {
        nextButton.rx.tap
            .subscribe { [weak self] _ in
                self?.viewModel.moveToNextQuestion(isNext: true)
            }
            .disposed(by: disposeBag)
        
        previousButton.rx.tap
            .subscribe { [weak self] _ in
                self?.viewModel.moveToNextQuestion(isNext: false)
            }
            .disposed(by: disposeBag)
        
        finishButton.rx.tap
            .subscribe { [weak self] _ in
                guard let selectedAnswers = self?.viewModel.selectedAnswersRelay.value else { return }
                guard let questionsCount = self?.viewModel.quizData.value?.questions?.count else { return }
                self?.coordinator?.goToResultScreen(selectedAnswers: selectedAnswers, questionsCount: questionsCount)
            }
            .disposed(by: disposeBag)
    }
    
    private func loadImageFromURL(_ url: URL) {
        photoImageView.kf.setImage(with: url)
    }
}

extension QuizViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

//
//  SelectedAnswer.swift
//  Quiz
//
//  Created by Magda Pękacka on 02/10/2023.
//

import Foundation

struct AnswerQuestion: Hashable {
    let selectedOption: Int
    let isCorrect: Bool
}

struct AnswerCellModel {
    let answer: Answer
    let isSelected: Bool
}

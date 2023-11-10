//
//  Quiz.swift
//  Quiz
//
//  Created by Magda Pękacka on 30/09/2023.
//

import Foundation

struct QuizList: Codable, Equatable {
    let count: Int
    let items: [Quiz]
    
    static func == (lhs: QuizList, rhs: QuizList) -> Bool {
        return lhs.items == rhs.items
    }
}

struct QuizDetails: Codable {
    let questions: [Question]?
    let title: String
    let type: String
    let content: String
    let tags: [Tag]
    let categories: [Category]
    let id: Int
    let mainPhoto: MainPhoto
    let category: Category
}

struct Quiz: Codable {
    let questions: Int
    let title: String
    let type: String
    let content: String
    let tags: [Tag]
    let categories: [Category]
    let id: Int
    let mainPhoto: MainPhoto
    let category: Category
}

struct Rate: Codable {
    let from: Int
    let to: Int
    let content: String
}

struct Answer: Codable {
    let order: Int
    let text: String
    let isCorrect: Int?
    
    private enum CodingKeys: String, CodingKey {
        case order
        case text
        case isCorrect
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let textString = try? container.decode(String.self, forKey: .text) {
            self.text = textString
        } else if let textInt = try? container.decode(Int.self, forKey: .text) {
            self.text = String(textInt)
        } else {
            throw MyDecodingError.invalidTextValue
        }
        
        self.order = try container.decode(Int.self, forKey: .order)
        self.isCorrect = try container.decodeIfPresent(Int.self, forKey: .isCorrect)
    }
    
    enum MyDecodingError: Error {
        case invalidTextValue
    }
}

struct Question: Codable {
    let answers: [Answer]
    let text: String
    let answer: String
    let type: String
    let order: Int
}

struct Tag: Codable {
    let uid: Int
    let name: String
    let type: String?
    let primary: Bool?
}

struct Category: Codable {
    let uid: Int?
    let secondaryCid: String?
    let name: String?
    let type: String?
}

struct MainPhoto: Codable {
    let author: String
    let width: Int
    let source: String
    let title: String
    let url: String
    let mediaId: String?
    let height: Int
}

extension Quiz: Equatable {
    static func == (lhs: Quiz, rhs: Quiz) -> Bool {
        return lhs.questions == rhs.questions &&
        lhs.title == rhs.title &&
        lhs.type == rhs.type &&
        lhs.content == rhs.content &&
        lhs.tags == rhs.tags &&
        lhs.categories == rhs.categories &&
        lhs.id == rhs.id &&
        lhs.mainPhoto == rhs.mainPhoto &&
        lhs.category == rhs.category
    }
}

extension Category: Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.uid == rhs.uid &&
        lhs.secondaryCid == rhs.secondaryCid &&
        lhs.name == rhs.name &&
        lhs.type == rhs.type
    }
}

extension Tag: Equatable {
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        return lhs.uid == rhs.uid &&
        lhs.name == rhs.name &&
        lhs.type == rhs.type &&
        lhs.primary == rhs.primary
    }
}

extension MainPhoto: Equatable {
    static func == (lhs: MainPhoto, rhs: MainPhoto) -> Bool {
        return lhs.author == rhs.author &&
        lhs.width == rhs.width &&
        lhs.source == rhs.source &&
        lhs.title == rhs.title &&
        lhs.url == rhs.url &&
        lhs.mediaId == rhs.mediaId &&
        lhs.height == rhs.height
    }
}


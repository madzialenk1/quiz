//
//  Quiz.swift
//  Quiz
//
//  Created by Magda Pękacka on 30/09/2023.
//

import Foundation

struct QuizList: Codable {
    let count: Int
    let items: [Quiz]
}

struct QuizDetails: Codable {
    let celebrity: Celebrity?
    let optionsEnabled: Bool?
    let rates: [Rate]?
    let questions: [Question]?
    let createdAt: String
    let sponsored: Bool
    let title: String
    let type: String
    let content: String
    let tags: [Tag]
    let buttonStart: String
    let shareTitle: String
    let categories: [Category]
    let id: Int
    let scripts: String?
    let mainPhoto: MainPhoto
    let category: Category
    let isBattle: Bool?
    let created: Int?
    let canonical: String?
    let productUrl: String?
    let publishedAt: String
    let latestResults: [Result]?
    let avgResult: Double?
    let resultCount: Int?
    let cityAvg: String?
    let cityTime: String?
    let cityCount: String?
    let userBattleDone: Bool?
    let sponsoredResults: SponsoredResults?
    
    private enum CodingKeys: String, CodingKey {
        case celebrity
        case optionsEnabled = "options_enabled"
        case rates
        case questions
        case createdAt
        case sponsored
        case title
        case type
        case content
        case tags
        case buttonStart
        case shareTitle
        case categories
        case id
        case scripts
        case mainPhoto
        case category
        case isBattle
        case created
        case canonical
        case productUrl
        case publishedAt
        case latestResults
        case avgResult
        case resultCount
        case cityAvg
        case cityTime
        case cityCount
        case userBattleDone
        case sponsoredResults
    }
}

struct Quiz: Codable {
    let questions: Int
    let createdAt: String
    let sponsored: Bool
    let title: String
    let type: String
    let content: String
    let tags: [Tag]
    let buttonStart: String
    let shareTitle: String
    let categories: [Category]
    let id: Int
    let mainPhoto: MainPhoto
    let category: Category
    let publishedAt: String
    let productUrls: [String: String]
}

struct Celebrity: Codable {
    let result: String
    let imageAuthor: String
    let imageHeight: String
    let imageUrl: String
    let show: Int
    let name: String
    let imageTitle: String
    let imageWidth: String
    let content: String
    let imageSource: String
}

struct Rate: Codable {
    let from: Int
    let to: Int
    let content: String
}

struct Answer: Codable {
    let image: ImagePhoto
    let order: Int
    let text: String
    let isCorrect: Int?
}

struct Question: Codable {
    let image: ImagePhoto
    let answers: [Answer]
    let text: String
    let answer: String
    let type: String
    let order: Int
}

struct Result: Codable {
    let city: Int
    let endDate: String
    let result: Double
    let resolveTime: Int
    
    private enum CodingKeys: String, CodingKey {
        case endDate = "end_date"
        case result
        case city
        case resolveTime
    }
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

struct ImagePhoto: Codable {
    let author: String
    let width: String
    let source: String
    let title: String?
    let url: String
    let mediaId: String?
    let height: String
}

struct SponsoredResults: Codable {
    let imageAuthor: String
    let imageHeight: String
    let imageUrl: String
    let imageWidth: String
    let textColor: String
    let content: String
    let mainColor: String
    let imageSource: String
}


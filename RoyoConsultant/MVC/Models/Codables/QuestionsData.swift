//
//  QuestionsData.swift
//  RoyoConsultant
//
//  Created by Sandeep Kumar on 12/11/20.
//  Copyright © 2020 SandsHellCreations. All rights reserved.
//

import Foundation

final class QuestionsData: Codable {
    var question: Question?
    var questions: [Question]?
    var after: String?
    var before: String?
    
    var can_ask_question: Bool?
}

final class Question: Codable {
    var id: Int?
    var title: String?
    var type: String?
    var created_by: User?
    var status: String?
    var created_at: String?
    var updated_at: String?
    var description: String?
    var answers: [Answer]?
    var amount: Double?
}

final class Answer: Codable {
    var answer: String?
    var created_at: String?
    var updated_at: String?
    var user: User?
}

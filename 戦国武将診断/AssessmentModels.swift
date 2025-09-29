import Foundation

struct Choice: Codable {
    let key: String
    let text: String
    let weights: [String:Int]
}

struct Question: Codable {
    let id: String
    let text: String
    let choices: [Choice]
}

struct AssessmentMeta: Codable {
    let title: String
    let traits: [String]
    let tiebreak: [String]
}

struct AssessmentDoc: Codable {
    let version: String
    let meta: AssessmentMeta
    let questions: [Question]
    let scoring: [String:String]?
}

struct Profile: Codable {
    let id: String
    let name: String
    let formula: String
    let summary: String
    let tips: [String]?
}

struct ProfilesDoc: Codable {
    let version: String
    let meta: [String:String]?
    let profiles: [Profile]
}
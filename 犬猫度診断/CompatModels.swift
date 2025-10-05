import Foundation

struct CompatChoice: Codable { let key: String; let text: String; let weights: [String:Int] }
struct CompatQuestion: Codable { let id: String; let text: String; let choices: [CompatChoice] }
struct CompatMeta: Codable { let title: String; let traits: [String]; let tiebreak: [String]? }
struct CompatDoc: Codable { let version: String; let meta: CompatMeta; let questions: [CompatQuestion]; let scoring: [String:String]? }
struct PairProfile: Codable { let id: String; let name: String; let summary: String; let formulaA: String?; let formulaB: String?; let tips: [String]? }
struct PairProfilesDoc: Codable { let version: String; let meta: [String:String]?; let profiles: [PairProfile] }

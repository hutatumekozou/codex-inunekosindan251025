import Foundation

struct DogCatChoice: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let dog: Int
    let cat: Int
}

struct DogCatQuestion: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let choices: [DogCatChoice]
}

struct ResultProfile {
    let title: String
    let subtitle: String
    let description: String
    let tips: String
}

struct ScoreSummary {
    let dogPoints: Int
    let catPoints: Int
    let dogPercent: Int
    let catPercent: Int
    let tier: DogCatTier
}

enum DogCatTier: String {
    case superDog        // 犬度90–100
    case dogStrong       // 犬度75–89
    case dogLight        // 犬度60–74
    case fiftyFifty      // 50/50 ぴったり
    case catLight        // 犬度40–49
    case catStrong       // 犬度25–39
    case superCat        // 犬度0–24
}

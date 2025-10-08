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

// MARK: - 9段階スコアリング対応

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
    let tier: DCTier9
}

enum DCTier9: String, CaseIterable {
    case dog100      // 犬度100%
    case dog81_99    // 犬度81–99%
    case dog66_80    // 犬度66–80%
    case dog51_65    // 犬度51–65%
    case fifty50     // 50/50
    case cat51_65    // 猫度51–65% (犬度35–49%)
    case cat66_80    // 猫度66–80% (犬度20–34%)
    case cat81_99    // 猫度81–99% (犬度1–19%)
    case cat100      // 猫度100% (犬度0%)
}

// MARK: 9段階: 画像アセット名（拡張子付き）
let dcResultImageName: [DCTier9: String] = [
    .dog100:   "dc_result_dog100.png",
    .dog81_99: "dc_result_dog81_99.png",
    .dog66_80: "dc_result_dog66_80.png",
    .dog51_65: "dc_result_dog51_65.png",
    .fifty50:  "dc_result_50_50.png",
    .cat51_65: "dc_result_cat51_65.png",
    .cat66_80: "dc_result_cat66_80.png",
    .cat81_99: "dc_result_cat81_99.png",
    .cat100:   "dc_result_cat100.png"
]

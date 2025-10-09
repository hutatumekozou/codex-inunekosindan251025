import SwiftUI

// MARK: 犬猫診断フロー全体（Q1〜Q20→結果）をナビ外で表示
struct DogCatFlowContainer: View {
    var onClose: () -> Void = {}

    var body: some View {
        DogCatQuizRootView(onClose: onClose)
            .hideNavBarCompletely() // ← Back保険
    }
}

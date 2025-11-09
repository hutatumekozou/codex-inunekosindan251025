import SwiftUI

/// 犬・猫の診断で使う共通背景
struct QuizBackground: View {
    var body: some View {
        Image("DogCatQuestionBG")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}

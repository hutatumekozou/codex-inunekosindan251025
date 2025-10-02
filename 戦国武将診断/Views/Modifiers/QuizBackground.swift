import SwiftUI

extension View {
    /// 質問画面専用：トリミングせずに縦長画像を敷く（レターボックス許容）
    func quizBackground() -> some View {
        ZStack {
            // 背景画像（トリミングなし、scaledToFit）
            Image("QuestionBG")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.all)
            
            // 可読性向上のため下部をほんのり暗くする
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.0),
                    Color.black.opacity(0.35)
                ]),
                startPoint: .center,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)
            
            // コンテンツ
            self
        }
    }
}

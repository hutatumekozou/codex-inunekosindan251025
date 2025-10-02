import SwiftUI

struct QuizScreen: View {
    @ObservedObject var vm: QuizViewModel
    var onFinish: (EvalResult) -> Void

    var body: some View {
        if let doc = vm.doc, vm.index < doc.questions.count {
            let q = doc.questions[vm.index]
            ZStack {
                // 背景画像（全画面）
                Image("QuizBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)

                // グラデーションオーバーレイ（文字を読みやすく）
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0.5),
                        Color.black.opacity(0.3),
                        Color.black.opacity(0.5)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(.all)

                // コンテンツ
                VStack(alignment: .leading, spacing: 20) {
                    // ヘッダー
                    VStack(alignment: .leading, spacing: 8) {
                        Text(doc.meta.title)
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))

                        Text("問題 \(vm.index+1)/\(doc.questions.count)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 20)

                    // 質問文
                    Text(q.text)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.8), radius: 4, x: 0, y: 2)
                        .padding(.vertical, 20)

                    // 選択肢
                    VStack(spacing: 16) {
                        ForEach(q.choices, id: \.key) { c in
                            Button(c.text) {
                                let wasLastQuestion = vm.index == doc.questions.count - 1
                                vm.select(c)

                                if wasLastQuestion, let r = vm.finish() {
                                    onFinish(r)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(0.4), lineWidth: 1)
                                    )
                            )
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, 24)
            }
        } else {
            ZStack {
                // 背景画像（ローディング時も）
                Image("QuizBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)

                Color.black.opacity(0.5)
                    .ignoresSafeArea(.all)

                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
            .onAppear {
                if vm.doc == nil {
                    vm.load()
                }
            }
        }
    }
}
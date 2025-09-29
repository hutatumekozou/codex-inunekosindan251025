import SwiftUI

struct ResultScreen: View {
    let result: EvalResult
    var onRestart: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("あなたに近いのは")
                    .font(.caption)

                Text(result.profile.name)
                    .font(.largeTitle)
                    .bold()

                Text(result.profile.summary)

                if let tip = result.profile.tips?.first {
                    Text("今日の一手：\(tip)")
                        .font(.subheadline)
                }

                Button("HOMEに戻る") {
                    onRestart()
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 12)
            }
            .padding()
        }
    }
}
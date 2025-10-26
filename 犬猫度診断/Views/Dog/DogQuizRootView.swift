import SwiftUI

struct DogQuizRootView: View {
    @State private var startQuiz = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("イヌ度診断")
                    .font(.largeTitle.bold())
                Text("あなたにぴったりのイヌタイプを診断！")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                Button(action: { startQuiz = true }) {
                    Text("診断スタート！")
                        .font(.headline)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 16)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }

                NavigationLink(destination: DogQuizQuestionView(), isActive: $startQuiz) {
                    EmptyView()
                }
                .hidden()
            }
            .padding()
        }
        .navigationViewStyle(.stack)
    }
}

struct DogQuizQuestionView: View {
    var body: some View {
        Text("Dog Quiz Questions...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
    }
}

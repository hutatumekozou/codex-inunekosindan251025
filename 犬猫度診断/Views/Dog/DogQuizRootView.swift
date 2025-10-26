import SwiftUI

struct DogQuizRootView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var startQuiz = false
    var onClose: () -> Void = {}

    private func finishAndDismiss() {
        startQuiz = false
        onClose()
        dismiss()
    }

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 12)

            Image(systemName: "pawprint.fill")
                .font(.system(size: 72))
                .foregroundColor(Color.orange)
                .padding(.bottom, 4)

            Text("イヌ度診断")
                .font(.largeTitle.bold())

            Text("20問に答えて、あなたにぴったりのイヌタイプを診断")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)

            Button {
                startQuiz = true
            } label: {
                Text("診断スタート！")
                    .font(.headline)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.12), radius: 8, y: 4)
            }
            .buttonStyle(.plain)
            .padding(.top, 12)

            Spacer()
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("イヌ度診断")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .background(
            NavigationLink(
                destination: DogQuizQuestionView(onExit: finishAndDismiss),
                isActive: $startQuiz
            ) {
                EmptyView()
            }
            .hidden()
        )
    }
}

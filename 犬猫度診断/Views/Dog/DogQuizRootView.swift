import SwiftUI

struct DogQuizRootView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var index: Int = 0
    @State private var answers: [DogChoice] = []
    @State private var result: DogResultSummary?

    private let questions = DogQuestions
    var onClose: () -> Void = {}

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Q\(index + 1)/\(questions.count)")
                    .font(.callout)
                    .foregroundColor(.secondary)

                ProgressView(value: Double(index + 1), total: Double(questions.count))
                    .tint(.orange)
                    .padding(.horizontal, 24)

                Text(questions[index].text)
                    .font(.title3.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 24)

                VStack(spacing: 12) {
                    ForEach(questions[index].choices) { choice in
                        Button {
                            handleChoice(choice)
                        } label: {
                            HStack {
                                Text(choice.text)
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.secondarySystemBackground))
                            )
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 24)
                    }
                }

                Spacer(minLength: 12)
            }
            .padding(.top, 24)
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("イヌ度診断")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(item: $result) { summary in
            DogResultView(summary: summary) {
                dismissQuiz()
            }
        }
    }

    private func handleChoice(_ choice: DogChoice) {
        answers.append(choice)
        if index + 1 < questions.count {
            index += 1
        } else {
            let total = dogTotalScore(answers)
            let type = dogType(for: total)
            result = DogResultSummary(total: total, type: type)
        }
    }

    private func dismissQuiz() {
        answers.removeAll()
        index = 0
        result = nil
        onClose()
        dismiss()
    }
}

struct DogResultView: View {
    let summary: DogResultSummary
    var onClose: () -> Void = {}

    private var percent: Int {
        let clamped = max(20, min(80, summary.total))
        return Int(round(Double(clamped - 20) / 60.0 * 100.0))
    }

    private var template: DogResultTemplate {
        DogResultTexts[summary.type] ?? DogResultTemplate(
            title: summary.type.rawValue.capitalized,
            subtitle: "",
            description: "",
            tips: ""
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                Text("イヌ度診断")
                    .font(.system(size: 32, weight: .heavy))
                    .padding(.top, 12)

                Text("🐶")
                    .font(.system(size: 72))

                Text(template.title)
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)

                Text(template.subtitle)
                    .foregroundColor(.secondary)

                HStack(spacing: 8) {
                    Image(systemName: "pawprint.fill")
                    Text("\(percent)%").bold()
                    Text("イヌ度")
                }
                .font(.headline)

                VStack(alignment: .leading, spacing: 12) {
                    Text("診断結果").font(.headline)
                    Text(template.description)
                        .fixedSize(horizontal: false, vertical: true)
                    Divider()
                    Text("相性のヒント").font(.headline)
                    Text(template.tips)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)))
                .padding(.horizontal, 24)

                Button {
                    onClose()
                } label: {
                    Label("HOMEに戻る", systemImage: "house.fill")
                        .font(.system(size: 17, weight: .semibold))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 28)
                        .background(Capsule().fill(Color(.systemBlue)))
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
                .padding(.top, 12)
            }
            .padding(.bottom, 32)
            .frame(maxWidth: .infinity)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

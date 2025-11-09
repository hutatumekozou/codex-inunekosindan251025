import SwiftUI

struct DogQuizQuestionView: View {
    @State private var index = 0
    @State private var answers: [DogChoice] = []
    @State private var showResult = false

    var onExit: () -> Void = {}

    private let questions: [DogQuestion] = DogQuestions

    private var currentQuestion: DogQuestion {
        questions[index]
    }

    private var questionProgressText: String {
        "Q\(index + 1)/\(questions.count)"
    }

    private func handleSelection(_ choice: DogChoice) {
        answers.append(choice)
        if index + 1 < questions.count {
            index += 1
        } else {
            showResult = true
        }
    }

    private func resetQuiz() {
        index = 0
        answers = []
    }

    var body: some View {
        ZStack {
            QuizBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(questionProgressText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .accessibilityLabel("Question \(index + 1) of \(questions.count)")

                    ProgressView(value: Double(index + 1), total: Double(questions.count))
                        .progressViewStyle(.linear)
                        .tint(Color.orange)

                    Text(currentQuestion.text)
                        .font(.title3.weight(.bold))
                        .padding(.top, 4)

                    VStack(spacing: 14) {
                        ForEach(currentQuestion.choices) { choice in
                            Button {
                                handleSelection(choice)
                            } label: {
                                HStack {
                                    Text(choice.text)
                                        .foregroundColor(.primary)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Spacer(minLength: 16)
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .background(Color.clear)
            }
        }
        .navigationBarBackButtonHidden(true)
        .fullScreenCover(isPresented: $showResult) {
            let total = dogTotalScore(answers)
            let type = dogType(for: total)
            let template = DogResultTexts[type] ?? DogResultTemplate(
                title: "イヌタイプ",
                subtitle: "",
                description: "",
                tips: ""
            )

            DogResultView(total: total, type: type, template: template) {
                showResult = false
                resetQuiz()
                onExit()
            }
            .interactiveDismissDisabled(true)
        }
    }
}

#Preview {
    DogQuizQuestionView()
}

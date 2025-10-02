import SwiftUI

@main
struct 戦国武将診断App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            HomeTabView()
        }
    }
}

struct HomeView: View {
    @State private var doc: AssessmentDoc?
    @State private var profiles: ProfilesDoc?
    @State private var answers: [String:Choice] = [:]
    @State private var index = 0
    @State private var result: EvalResult?

    var body: some View {
        Group {
            if let res = result {
                ResultView(res: res) {
                    // Reset for retry
                    self.result = nil
                    self.answers = [:]
                    self.index = 0
                }
            } else if let doc = doc, let _ = profiles {
                QuestionView(doc: doc, index: $index, answers: $answers) {
                    if let p = profiles,
                       let r = AssessmentEvaluator.evaluate(answers: answers, doc: doc, profiles: p) {
                        result = r
                    }
                }
            } else {
                VStack(spacing: 12) {
                    Text("戦国武将診断")
                        .font(.title)
                    Button("診断を開始") {
                        load()
                    }
                }
                .padding()
            }
        }
    }

    func load() {
        do {
            self.doc = try AssessmentRepository.loadQuestions(name: "diag_sengoku_v1.json")
            self.profiles = try AssessmentRepository.loadProfiles(name: "diag_sengoku_results.json")
            self.index = 0
            self.answers = [:]
        } catch {
            print("load error:", error)
        }
    }
}

struct QuestionView: View {
    let doc: AssessmentDoc
    @Binding var index: Int
    @Binding var answers: [String:Choice]
    var onFinish: () -> Void

    var body: some View {
        let q = doc.questions[index]
        VStack(alignment: .leading, spacing: 16) {
            Text("\(doc.meta.title)")
                .font(.headline)

            Text("\(index+1)/\(doc.questions.count)  \(q.text)")
                .font(.title3)

            ForEach(q.choices, id: \.key) { c in
                Button(c.text) {
                    answers[q.id] = c
                    if index + 1 < doc.questions.count {
                        index += 1
                    } else {
                        onFinish()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding()
    }
}

struct ResultView: View {
    let res: EvalResult
    let onRetry: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("あなたに近いのは")
                .font(.caption)

            Text(res.profile.name)
                .font(.largeTitle)
                .bold()

            Text(res.profile.summary)
                .font(.body)

            if let tip = res.profile.tips?.first {
                Text("今日の一手：\(tip)")
            }

            Button("もう一度") {
                onRetry()
            }
            .padding(.top)

            Text("※この診断結果はエンタメ用途です。実際の性格や能力を断定するものではありません。")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top)
        }
        .padding()
    }
}
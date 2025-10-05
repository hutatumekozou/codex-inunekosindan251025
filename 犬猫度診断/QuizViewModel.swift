import Foundation

final class QuizViewModel: ObservableObject {
    @Published var doc: AssessmentDoc?
    @Published var profiles: ProfilesDoc?
    @Published var answers: [String:Choice] = [:]
    @Published var index: Int = 0

    func load() {
        // JSON が無ければフォールバックを自動採用
        doc = AssessmentRepository.loadQuestions(name: "diag_sengoku_v1.json")
        profiles = AssessmentRepository.loadProfiles(name: "diag_sengoku_results.json")
        answers = [:]
        index = 0
    }

    func select(_ c: Choice) {
        guard let q = doc?.questions[index] else { return }
        answers[q.id] = c
        if let d = doc, index + 1 < d.questions.count {
            index += 1
        }
    }

    func finish() -> EvalResult? {
        guard let d = doc, let p = profiles else { return nil }
        return AssessmentEvaluator.evaluate(answers: answers, doc: d, profiles: p)
    }
}
import SwiftUI

struct QuizScreen: View {
    @ObservedObject var vm: QuizViewModel
    var onFinish: (EvalResult) -> Void

    var body: some View {
        if let doc = vm.doc, vm.index < doc.questions.count {
            let q = doc.questions[vm.index]
            VStack(alignment: .leading, spacing: 16) {
                Text(doc.meta.title)
                    .font(.headline)

                Text("\(vm.index+1)/\(doc.questions.count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(q.text)
                    .font(.title3)
                    .bold()

                ForEach(q.choices, id: \.key) { c in
                    Button(c.text) {
                        let wasLastQuestion = vm.index == doc.questions.count - 1
                        vm.select(c)

                        if wasLastQuestion, let r = vm.finish() {
                            onFinish(r)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Spacer()
            }
            .padding()
        } else {
            ProgressView()
                .onAppear {
                    if vm.doc == nil {
                        vm.load()
                    }
                }
        }
    }
}
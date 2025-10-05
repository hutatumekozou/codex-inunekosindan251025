import SwiftUI

struct DogCatQuizRootView: View {
    @State private var index = 0
    @State private var dog = 0
    @State private var cat = 0
    @State private var finished = false

    var body: some View {
        NavigationView {
            Group {
                if finished {
                    let summary = DogCatScoringEngine.summarize(dog: dog, cat: cat)
                    DogCatResultView(summary: summary) {
                        // リセット
                        index = 0
                        dog = 0
                        cat = 0
                        finished = false
                    }
                } else {
                    DogCatQuestionView(
                        question: dogCatQuestions[index],
                        onSelect: { choice in
                            dog += choice.dog
                            cat += choice.cat
                            if index + 1 < dogCatQuestions.count {
                                index += 1
                            } else {
                                finished = true
                            }
                        },
                        progressText: "Q\(index+1)/\(dogCatQuestions.count)"
                    )
                }
            }
            .navigationTitle("犬猫度診断")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DogCatQuestionView: View {
    let question: DogCatQuestion
    let onSelect: (DogCatChoice) -> Void
    let progressText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(progressText).font(.caption).foregroundColor(.secondary)

            // プログレスバー
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)

                    let progress = Double(Int(progressText.split(separator: "/")[0].dropFirst()) ?? 1) / Double(dogCatQuestions.count)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * CGFloat(progress), height: 8)
                }
            }
            .frame(height: 8)
            .padding(.bottom, 8)

            Text(question.text).font(.title3).bold().padding(.bottom, 8)

            ForEach(question.choices) { choice in
                Button {
                    onSelect(choice)
                } label: {
                    HStack {
                        Text(choice.text)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
            }
            Spacer()
        }
        .padding()
    }
}

struct DogCatResultView: View {
    let summary: ScoreSummary
    let onRetry: () -> Void

    var body: some View {
        let profile = DogCatScoringEngine.profile(for: summary.tier)
        ScrollView {
            VStack(spacing: 16) {
                Text(profile.title).font(.largeTitle).bold()
                Text(profile.subtitle).font(.headline).foregroundColor(.secondary)

                HStack(spacing: 20) {
                    VStack {
                        Text("🐶").font(.largeTitle)
                        Text("\(summary.dogPercent)%").font(.title2).bold()
                        Text("犬度").font(.caption).foregroundColor(.secondary)
                    }

                    VStack {
                        Text("🐱").font(.largeTitle)
                        Text("\(summary.catPercent)%").font(.title2).bold()
                        Text("猫度").font(.caption).foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(16)

                VStack(alignment: .leading, spacing: 12) {
                    Text("診断結果")
                        .font(.headline)
                    Text(profile.description)
                        .fixedSize(horizontal: false, vertical: true)

                    Divider()

                    Text("相性のヒント")
                        .font(.headline)
                    Text(profile.tips)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(16)

                Button("もう一度診断する") {
                    onRetry()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.top, 8)
            }
            .padding()
        }
    }
}

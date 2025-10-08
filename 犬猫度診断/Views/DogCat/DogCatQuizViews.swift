import SwiftUI

struct DogCatQuizRootView: View {
    @Environment(\.dismiss) var dismiss
    @State private var index = 0
    @State private var dog = 0
    @State private var cat = 0
    @State private var finished = false

    var body: some View {
        NavigationView {
            Group {
                if finished {
                    let summary = DogCatScoringEngine.summarize(dog: dog, cat: cat)
                    DogCatResultView(summary: summary)
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
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct DogCatQuestionView: View {
    let question: DogCatQuestion
    let onSelect: (DogCatChoice) -> Void
    let progressText: String

    var body: some View {
        ZStack {
            // 背景画像（下部に配置、犬猫が画面に収まるように）
            GeometryReader { geometry in
                Image("DogCatQuestionBG")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width)
                    .position(x: geometry.size.width / 2, y: geometry.size.height - 310)
            }
            .ignoresSafeArea()

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
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: 犬猫結果: 1行インライン％表示（サイズ半分）
struct InlineStat: View {
    let emoji: String
    let percent: Int
    var body: some View {
        HStack(spacing: 4) {
            Text(emoji)
                .font(.system(size: 14))
            Text("\(percent)%")
                .font(.system(size: 18, weight: .black))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .center) // 左右で等幅
    }
}

struct DogCatResultView: View {
    @Environment(\.dismiss) var dismiss
    let summary: ScoreSummary

    var body: some View {
        let profile = DogCatScoringEngine.profile(for: summary.tier)
        ScrollView {
            VStack(spacing: 16) {
                // MARK: 犬猫結果アイコン
                if let name = dcResultImageName[summary.tier],
                   let uiImg = UIImage(named: name) {
                    Image(uiImage: uiImg)
                       .resizable()
                       .aspectRatio(contentMode: .fit)
                       .frame(maxWidth: 260, maxHeight: 260)
                       .accessibilityHidden(true)
                }

                Text(profile.title).font(.largeTitle).bold()
                Text(profile.subtitle).font(.headline).foregroundColor(.secondary)

                // MARK: 犬猫結果: ％サマリー（横1行・ラベルなし・小サイズ）
                HStack(spacing: 0) {
                    InlineStat(emoji: "🐶", percent: summary.dogPercent)
                        .padding(.vertical, 8)

                    Divider().frame(height: 22)

                    InlineStat(emoji: "🐱", percent: summary.catPercent)
                        .padding(.vertical, 8)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 18)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.systemGray6))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.black.opacity(0.06), lineWidth: 1)
                )
                .padding(.horizontal, 20)

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

                Button {
                    let goHome = { dismiss() }
                    if let vc = UIApplication.shared.topViewController {
                        AdsManager.shared.show(from: vc, onClosed: goHome)
                    } else {
                        goHome()
                    }
                } label: {
                    Label("HOMEに戻る", systemImage: "house.fill")
                        .labelStyle(.titleAndIcon)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                .font(.subheadline)
                .padding(.top, 8)
            }
            .padding()
            .offset(y: -14) // 0.5cm上に移動
        }
    }
}

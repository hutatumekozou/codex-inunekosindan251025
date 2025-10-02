import SwiftUI

struct ResultScreen: View {
    let result: EvalResult
    let allProfiles: [Profile]
    var onRestart: () -> Void

    // アセット名は profile.id と同一（例: nobunaga, ieyasu...）
    private var assetName: String { result.profile.id }

    private func nameForProfile(id: String) -> String {
        allProfiles.first(where: { $0.id == id })?.name ?? id
    }

    var body: some View {
        ZStack {
            // 背景画像（全体・トリミングなし、scaledToFit）
            Image("ResultBG")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(.all)

            // 可読性向上のため下部をほんのり暗くする
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.0),
                    Color.black.opacity(0.35)
                ]),
                startPoint: .center,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)

            // コンテンツ
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // --- ヒーロー画像（人物＋背景を同じ高さで表示） ---
                    ResultHeroView(
                        bgImageName: "QuestionBG",
                        portrait: Image.resolve(assetName) ?? Image(systemName: "person.crop.circle")
                    )

                    Text("あなたに近いのは")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))

                    Text(result.profile.name)
                        .font(.largeTitle)
                        .bold()
                        .lineLimit(1)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.8), radius: 4, x: 0, y: 2)

                    Text(result.profile.summary)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.6), radius: 3, x: 0, y: 1)

                    // --- 今日の一手（単発表示） ---
                    TodayTipView(tip: result.profile.tips?.first)

                    // --- 相性の良い武将 ---
                    if let comp = result.profile.compatibility, !comp.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("相性の良い武将")
                                .font(.headline)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.8), radius: 4, x: 0, y: 2)
                            HStack(spacing: 8) {
                                ForEach(comp, id: \.self) { profId in
                                    Text(nameForProfile(id: profId))
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.9))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.white.opacity(0.2))
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                        .padding(.top, 8)
                    }

                    // --- ラッキーカラー ---
                    if let colorName = result.profile.luckyColorName,
                       let colorHex = result.profile.luckyColorHex {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("ラッキーカラー")
                                .font(.headline)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.8), radius: 4, x: 0, y: 2)
                            HStack(spacing: 8) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color(hex: colorHex) ?? .gray.opacity(0.3))
                                    .frame(width: 24, height: 24)
                                    .shadow(radius: 2)
                                Text("\(colorName) (\(colorHex))")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            .accessibilityLabel("ラッキーカラー \(colorName)")
                        }
                        .padding(.top, 8)
                    }

                    Button("HOMEに戻る") {
                        onRestart()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 8)

                    Text("※この診断結果はエンタメ用途です。実際の性格や能力を断定するものではありません。")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                        .shadow(color: .black.opacity(0.6), radius: 3, x: 0, y: 1)
                        .padding(.top, 8)
                }
                .padding()
            }
        }
    }
}

// MARK: - ヒーロー画像ビュー（背景＋人物を同じ高さで表示）
fileprivate struct ResultHeroView: View {
    let bgImageName: String?
    let portrait: Image
    let H: CGFloat = 260  // 共通高さ（必要に応じて調整）

    var body: some View {
        ZStack(alignment: .center) {
            // 背景（人物と同じ高さ）
            Group {
                if let name = bgImageName, let bg = Image.resolve(name) {
                    bg
                        .resizable()
                        .scaledToFill()
                        .frame(height: H)
                        .clipped()
                        .overlay(
                            LinearGradient(
                                colors: [.black.opacity(0.0), .black.opacity(0.25)],
                                startPoint: .center,
                                endPoint: .bottom
                            )
                        )
                        .accessibilityHidden(true)
                } else {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.black.opacity(0.08))
                        .frame(height: H)
                }
            }

            // 人物（カード表示・はみ出し防止）
            portrait
                .resizable()
                .scaledToFill()
                .frame(height: H)
                .frame(maxWidth: 360)  // タブレット等でデカくなり過ぎ防止
                .clipped()
                .cornerRadius(14)
                .shadow(radius: 8)
                .padding(.horizontal, 24)
        }
        .padding(.top, 8)  // Safe Area 内に収める
    }
}

// MARK: - 今日の一手ビュー（単発表示）
fileprivate struct TodayTipView: View {
    let tip: String?

    var body: some View {
        if let t = tip, !t.isEmpty {
            VStack(alignment: .leading, spacing: 6) {
                Text("今日の一手")
                    .font(.headline)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.8), radius: 4, x: 0, y: 2)
                Text(t)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(color: .black.opacity(0.6), radius: 3, x: 0, y: 1)
            }
            .accessibilityElement(children: .combine)
            .padding(.top, 8)
        }
    }
}

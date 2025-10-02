import SwiftUI

struct ResultScreen: View {
    let result: EvalResult
    var onRestart: () -> Void

    // アセット名は profile.id と同一（例: nobunaga, ieyasu...）
    private var assetName: String { result.profile.id }

    var body: some View {
        ZStack {
            // 背景画像（トリミングなし、scaledToFit）
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

                    // --- 追加：イラスト（アスペクト比維持・角丸・影） ---
                    Group {
                        if let img = Image.resolve(assetName) {
                            img.resizable()
                              .scaledToFit()
                              .frame(maxWidth: .infinity, maxHeight: 240)
                              .clipShape(RoundedRectangle(cornerRadius: 16))
                              .shadow(radius: 6)
                        } else {
                            // プレースホルダ
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray.opacity(0.1))
                                .frame(maxWidth: .infinity, minHeight: 160, maxHeight: 240)
                                .overlay(
                                    Text("画像が見つかりません: \(assetName)")
                                        .font(.footnote)
                                        .foregroundColor(.white)
                                        .padding()
                                )
                        }
                    }
                    .padding(.bottom, 8)

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

                    if let tip = result.profile.tips?.first {
                        Text("今日の一手：\(tip)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                            .shadow(color: .black.opacity(0.6), radius: 3, x: 0, y: 1)
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
import SwiftUI

struct ResultScreen: View {
    let result: EvalResult
    var onRestart: () -> Void

    // アセット名は profile.id と同一（例: nobunaga, ieyasu...）
    private var assetName: String { result.profile.id }

    var body: some View {
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
                                    .foregroundStyle(.secondary)
                                    .padding()
                            )
                    }
                }
                .padding(.bottom, 8)

                Text("あなたに近いのは")
                    .font(.caption)

                Text(result.profile.name)
                    .font(.largeTitle)
                    .bold()
                    .lineLimit(1)

                Text(result.profile.summary)
                    .fixedSize(horizontal: false, vertical: true)

                if let tip = result.profile.tips?.first {
                    Text("今日の一手：\(tip)")
                        .font(.subheadline)
                }

                Button("HOMEに戻る") {
                    onRestart()
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 8)

                Text("※この診断結果はエンタメ用途です。実際の性格や能力を断定するものではありません。")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
            }
            .padding()
        }
    }
}
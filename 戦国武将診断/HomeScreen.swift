import SwiftUI

struct HomeScreen: View {
    var startAction: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // ヘッダ画像：プレースホルダ（後で差し替え）
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.1))
                    Text("メインビジュアル")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .frame(height: 220)
                .padding(.horizontal)

                Text("戦国武将診断")
                    .font(.system(size: 34, weight: .bold))

                Button {
                    startAction()
                } label: {
                    Text("診断スタート!!")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal)

                // 参考イメージ枠（小さな説明）
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .frame(height: 140)
                    .overlay(
                        Text("ここにミニ説明やイラスト")
                            .foregroundStyle(.secondary)
                    )
                    .padding(.horizontal)

                Text("※本アプリはエンタメ用途です。")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer(minLength: 20)
            }
            .padding(.top, 24)
        }
    }
}

struct AboutScreen: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("このアプリについて")
                    .font(.title2)
                    .bold()

                Text("・本結果はエンタメ用途です。\n・歴史上の人物像は諸説あります。\n・個人の人格断定や差別的利用は禁止です。")

                Text("バージョン：1.0")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}
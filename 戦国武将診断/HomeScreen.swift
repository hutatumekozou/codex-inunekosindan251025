import SwiftUI

struct HomeScreen: View {
    var startAction: () -> Void

    var body: some View {
        ZStack {
            // 背景画像（全画面）
            Image("AppHero")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)

            // グラデーションオーバーレイ（文字を読みやすく）
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.4),
                    Color.black.opacity(0.1),
                    Color.black.opacity(0.4)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)

            // コンテンツ
            VStack(spacing: 24) {
                Spacer()

                // タイトル
                Text("戦国大名診断")
                    .font(.system(size: 48, weight: .bold, design: .serif))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.8), radius: 8, x: 0, y: 4)
                    .padding(.top, 60)

                Spacer()

                // スタートボタン
                Button {
                    startAction()
                } label: {
                    Text("診断スタート")
                        .font(.system(size: 24, weight: .bold))
                        .frame(maxWidth: 280)
                        .padding(.vertical, 20)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.red.opacity(0.8), Color.orange.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)

                // 注意書き
                Text("※本アプリはエンタメ用途です")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                    .shadow(color: .black.opacity(0.6), radius: 4, x: 0, y: 2)
                    .padding(.bottom, 40)
            }
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
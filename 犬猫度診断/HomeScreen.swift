import SwiftUI

struct HomeScreen: View {
    var startAction: () -> Void
    @State private var showDogCatQuiz = false
    @State private var showCompatQuiz = false

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

                VStack(spacing: 16) {
                    // 戦国大名診断ボタン
                    Button {
                        startAction()
                    } label: {
                        Text("戦国大名診断")
                            .font(.system(size: 20, weight: .bold))
                            .frame(maxWidth: 280)
                            .padding(.vertical, 16)
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

                    // 犬猫度診断ボタン
                    Button {
                        showDogCatQuiz = true
                    } label: {
                        HStack {
                            Text("🐶🐱")
                            Text("犬猫度診断")
                                .font(.system(size: 20, weight: .bold))
                        }
                        .frame(maxWidth: 280)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
                    }

                    // 相性診断ボタン
                    Button {
                        showCompatQuiz = true
                    } label: {
                        HStack {
                            Text("💕")
                            Text("相性診断")
                                .font(.system(size: 20, weight: .bold))
                        }
                        .frame(maxWidth: 280)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.pink.opacity(0.8), Color.red.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
                    }
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
        .sheet(isPresented: $showDogCatQuiz) {
            DogCatQuizRootView()
        }
        .sheet(isPresented: $showCompatQuiz) {
            CompatHomeView()
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
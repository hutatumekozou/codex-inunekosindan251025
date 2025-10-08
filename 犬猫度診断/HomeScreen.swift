// MARK: - 起動ホーム → 診断選択（確実遷移版）
import SwiftUI

struct HomeScreen: View {
    @State private var goSelection = false

    var body: some View {
        ZStack {
            DogCatStartView {
                print("[Home] start tapped")
                goSelection = true
            }

            // 画面に存在する NavigationLink（不可視）
            NavigationLink(
                destination: QuizSelectionScreen(),
                isActive: $goSelection
            ) {
                EmptyView()
            }
            .frame(width: 0, height: 0)
            .opacity(0)
            .accessibilityHidden(true)
        }
    }
}

// MARK: 診断選択 - 戦国診断を一時非表示
struct QuizSelectionScreen: View {
    @Environment(\.dismiss) var dismiss
    // @State private var showSamuraiQuiz = false  // 戦国診断用（一時無効化）
    @State private var showDogCatQuiz = false

    var body: some View {
        ZStack {
            // 背景色
            Color(red: 1.0, green: 0.965, blue: 0.917)
                .ignoresSafeArea()

            VStack(spacing: 40) {
                Text("診断を選んでください")
                    .font(.title)
                    .bold()
                    .padding(.top, 60)

                Spacer()

                // MARK: 戦国大名診断ボタン - 一時非表示（戻すときはコメント解除）
                /*
                Button(action: {
                    print("[DEBUG] 戦国大名診断ボタンがタップされました")
                    showSamuraiQuiz = true
                }) {
                    VStack(spacing: 12) {
                        Text("⚔️")
                            .font(.system(size: 60))
                        Text("戦国大名診断")
                            .font(.title2)
                            .bold()
                        Text("あなたはどの戦国武将？")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 30)
                */

                // 犬猫度診断ボタン
                Button(action: {
                    print("[DEBUG] 犬猫度診断ボタンがタップされました")
                    showDogCatQuiz = true
                }) {
                    VStack(spacing: 12) {
                        Image("DogCatIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                        Text("犬猫度診断")
                            .font(.title2)
                            .bold()
                        Text("あなたはいぬタイプ？ねこタイプ？")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 30)

                Spacer()
            }

            // NavigationLinkを隠して配置
            // NavigationLink(destination: QuizScreen(vm: QuizViewModel()) { result in
            //     // 結果画面への遷移はAppRouterで管理
            // }, isActive: $showSamuraiQuiz) { EmptyView() }
            // .hidden()

            NavigationLink(destination: DogCatQuizRootView(), isActive: $showDogCatQuiz) { EmptyView() }
            .hidden()
        }
        .navigationBarHidden(true)
    }
}


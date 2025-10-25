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

// MARK: - 診断選択（犬猫 上 / ネコ 下）
struct QuizSelectionScreen: View {
    @State private var goDogCat = false
    @State private var goCatOnly = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("診断を選んでください")
                    .font(.system(size: 28, weight: .heavy))

                SelectionCard(
                    imageName: "DogCatIcon",
                    title: "犬猫度診断",
                    subtitle: "あなたはいぬタイプ？ ねこタイプ？"
                ) {
                    goDogCat = true
                }

                SelectionCard(
                    imageName: "CatOnlyCard",
                    title: "ネコ度診断",
                    subtitle: "あなたと相性ぴったりのネコがわかる♪"
                ) {
                    goCatOnly = true
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 40)
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .background(
            NavigationLink(
                destination: DogCatQuizRootView(onClose: { goDogCat = false }),
                isActive: $goDogCat
            ) { EmptyView() }
                .hidden()
        )
        .background(
            NavigationLink(
                destination: CatQuizRootView(onClose: { goCatOnly = false }),
                isActive: $goCatOnly
            ) { EmptyView() }
                .hidden()
        )
    }
}

// MARK: - 共通カード
struct SelectionCard: View {
    let imageName: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 14) {
                if let image = Image.dc_fromAssets(imageName) ?? Image.fromAssets(imageName) {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 140)
                        .clipped()
                } else {
                    Color.gray.opacity(0.1)
                        .frame(height: 140)
                        .overlay(
                            Text("画像が見つかりません")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        )
                }
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(#colorLiteral(red: 0.0, green: 0.42, blue: 1.0, alpha: 1)))
                Text(subtitle)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 22)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(24)
            .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 8)
        }
        .buttonStyle(.plain)
    }
}

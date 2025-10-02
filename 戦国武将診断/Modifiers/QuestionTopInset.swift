import SwiftUI

/// 質問画面の上端がノッチ/ステータスバーに被らないようにする共通余白
/// 「安全域(top) + 24pt」を自動で追加
struct QuestionTopInset: ViewModifier {
    var extra: CGFloat = 24

    func body(content: Content) -> some View {
        GeometryReader { proxy in
            let top = proxy.safeAreaInsets.top
            content
                .padding(.top, top + extra)
        }
    }
}

extension View {
    /// 質問画面用の上部余白を追加（SafeArea top + extra）
    /// - Parameter extra: SafeArea上端からの追加余白（デフォルト24pt）
    func questionTopInset(extra: CGFloat = 24) -> some View {
        modifier(QuestionTopInset(extra: extra))
    }
}

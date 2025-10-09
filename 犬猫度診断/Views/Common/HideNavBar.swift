import SwiftUI

// MARK: 共通: この画面ではナビバー/戻るを完全非表示
extension View {
    func hideNavBarCompletely() -> some View {
        self
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)                   // iOS 15
            .toolbar {                                   // iOS 16+ の保険
                ToolbarItem(placement: .navigationBarLeading) { EmptyView() }
                ToolbarItem(placement: .navigationBarTrailing) { EmptyView() }
            }
    }
}

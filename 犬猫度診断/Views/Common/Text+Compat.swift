import SwiftUI

// MARK: iOS 15互換 - monospaced() は iOS 16.4+ のみ
extension Text {
    /// iOS 16.4+ の monospaced() の互換ラッパー
    /// iOS 15では .font(.system(.body, design: .monospaced)) にフォールバック
    @ViewBuilder func compatMonospaced() -> some View {
        if #available(iOS 16.4, *) {
            self.monospaced()
        } else {
            // iOS 15: font に monospaced デザインを直接指定
            self.font(.system(.body, design: .monospaced))
        }
    }
}

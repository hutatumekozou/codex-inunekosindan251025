import SwiftUI

struct HomeBackButton: View {
    var body: some View {
        Button {
            AdsManager.shared.show {
                NotificationCenter.default.post(name: .goHome, object: nil)
            }
        } label: {
            Label("HOMEに戻る", systemImage: "house.fill")
                .labelStyle(.titleAndIcon)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.small)
        .font(.subheadline)
        .accessibilityLabel("ホームに戻る")
    }
}

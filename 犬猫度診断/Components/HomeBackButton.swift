import SwiftUI

struct HomeBackButton: View {
    var body: some View {
        Button {
            let goHome = { NotificationCenter.default.post(name: .goHome, object: nil) }
            if let vc = UIApplication.shared.topViewController {
                AdsManager.shared.show(from: vc, onClosed: goHome)
            } else {
                goHome()
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

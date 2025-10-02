import Foundation
import GoogleMobileAds
import UIKit

final class AdsManager: NSObject {
    static let shared = AdsManager()

    private var interstitial: InterstitialAd?
    private var isLoading = false

    // SDK started フラグ（start完了までロードしない）
    static var isSDKStarted = false

    #if DEBUG
    private let adUnitID = "ca-app-pub-3940256099942544/4411468910" // テスト
    #else
    private let adUnitID = "ca-app-pub-8365176591962448/2009549494" // 本番
    #endif

    func preload() {
        guard AdsManager.isSDKStarted else {
            print("[Ads] skip preload: SDK not started yet")
            return
        }
        guard !isLoading, interstitial == nil else { return }
        isLoading = true
        let request = Request()
        print("[Ads] preload interstitial: \(adUnitID)")
        InterstitialAd.load(with: adUnitID, request: request) { [weak self] ad, err in
            guard let self = self else { return }
            self.isLoading = false
            if let err = err {
                print("[Ads] preload failed: \(err.localizedDescription)")
                self.interstitial = nil
                return
            }
            self.interstitial = ad
            self.interstitial?.fullScreenContentDelegate = self
            print("[Ads] preload success")
        }
    }

    func show(from rootVC: UIViewController, onClosed: @escaping () -> Void) {
        guard AdsManager.isSDKStarted else {
            print("[Ads] show skipped: SDK not started")
            onClosed()
            return
        }
        if let ad = interstitial {
            print("[Ads] show interstitial")
            ad.present(from: rootVC)
            self.onClosed = onClosed
        } else {
            print("[Ads] not ready -> skip and call onClosed()")
            onClosed()
            preload()
        }
    }

    // MARK: - private
    private var onClosed: (() -> Void)?
}

extension AdsManager: FullScreenContentDelegate {
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("[Ads] present failed: \(error.localizedDescription)")
        onClosed?(); onClosed = nil
        interstitial = nil
        preload()
    }
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("[Ads] dismissed")
        onClosed?(); onClosed = nil
        interstitial = nil
        preload()
    }
}

/// 便利: 最前面のVC
extension UIApplication {
    var topViewController: UIViewController? {
        guard let scene = connectedScenes.first as? UIWindowScene,
              let root = scene.keyWindow?.rootViewController else { return nil }
        var top = root
        while let presented = top.presentedViewController { top = presented }
        return top
    }
}

extension UIWindowScene {
    var keyWindow: UIWindow? { windows.first { $0.isKeyWindow } }
}

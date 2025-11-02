import Foundation
import UIKit
import GoogleMobileAds

/// インタースティシャル広告の一元管理
final class AdsManager: NSObject {

    static let shared = AdsManager()

    private var interstitial: InterstitialAd?
    private var pendingCompletion: (() -> Void)?

    // MARK: - UnitID
    private var interstitialUnitID: String {
        #if DEBUG
        // Google公式テストID
        return "ca-app-pub-3940256099942544/4411468910"
        #else
        // 本番ID
        return "ca-app-pub-8365176591962448/5717408957"
        #endif
    }

    private override init() {
        super.init()
        preload()
    }

    // MARK: - load
    func preload() {
        // 旧: GADRequest() → 新: Request()
        let request = Request()

        // 旧: InterstitialAd.load(withAdUnitID:..., request:...) → 新: load(with:request:completionHandler:)
        InterstitialAd.load(with: interstitialUnitID, request: request) { [weak self] ad, error in
            guard let self else { return }
            if let error = error {
                print("[AdsManager] load failed: \(error.localizedDescription)")
                self.interstitial = nil
                return
            }
            self.interstitial = ad
            ad?.fullScreenContentDelegate = self
            print("[AdsManager] load success")
        }
    }

    // MARK: - show
    /// 広告を表示し、閉じられたら completion を呼ぶ
    func show(from root: UIViewController? = UIApplication.shared.topViewController(),
              completion: (() -> Void)? = nil) {

        pendingCompletion = completion

        guard let ad = interstitial, let root = root else {
            print("[AdsManager] not ready, continue without ad")
            completion?()
            preload()
            return
        }

        // 新API: present(from:)
        ad.present(from: root)
    }
}

// MARK: - FullScreenContentDelegate
extension AdsManager: FullScreenContentDelegate {

    func adDidDismissFullScreenContent(_ ad: any FullScreenPresentingAd) {
        print("[AdsManager] dismissed -> call completion & reload")
        pendingCompletion?()
        pendingCompletion = nil
        preload()
    }

    func ad(_ ad: any FullScreenPresentingAd,
            didFailToPresentFullScreenContentWithError error: any Error) {
        print("[AdsManager] failed to present: \(error.localizedDescription)")
        pendingCompletion?()
        pendingCompletion = nil
        preload()
    }
}

// MARK: - UIViewController helper
extension UIApplication {
    func topViewController(
        _ base: UIViewController? = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController
    ) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return topViewController(tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}

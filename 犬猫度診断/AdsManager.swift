import Foundation
import GoogleMobileAds
import UIKit

final class AdsManager: NSObject {
  static let shared = AdsManager()
  static var isSDKStarted = false

  private var interstitial: InterstitialAd?
  private var isLoading = false

  #if DEBUG
  private let adUnitID = "ca-app-pub-3940256099942544/4411468910" // Google公式テストID
  #else
  private let adUnitID = "ca-app-pub-8365176591962448/5717408957"
  #endif

  func preload() {
    guard AdsConfig.adsEnabled else { Log.ads("preload skipped: disabled"); return }
    guard Self.isSDKStarted else { Log.ads("preload skipped: SDK not started"); return }
    guard !isLoading, interstitial == nil else { return }
    isLoading = true
    Log.ads("preload interstitial:", adUnitID)
    InterstitialAd.load(with: adUnitID, request: Request()) { [weak self] ad, err in
      guard let self else { return }
      self.isLoading = false
      if let err = err {
        Log.ads("preload failed:", err.localizedDescription); self.interstitial = nil; return
      }
      self.interstitial = ad
      self.interstitial?.fullScreenContentDelegate = self
      Log.ads("preload success")
    }
  }

  func show(from rootVC: UIViewController, onClosed: @escaping () -> Void) {
    guard AdsConfig.adsEnabled else { Log.ads("show skipped: disabled"); onClosed(); return }
    guard Self.isSDKStarted else { Log.ads("show skipped: SDK not started"); onClosed(); return }
    if let ad = interstitial {
      Log.ads("show interstitial"); ad.present(from: rootVC); self.onClosed = onClosed
    } else {
      Log.ads("not ready -> skip"); onClosed(); preload()
    }
  }
  private var onClosed: (() -> Void)?
}

extension AdsManager: FullScreenContentDelegate {
  func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
    Log.ads("present failed:", error.localizedDescription); onClosed?(); onClosed=nil; interstitial=nil; preload()
  }
  func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
    Log.ads("dismissed"); onClosed?(); onClosed=nil; interstitial=nil; preload()
  }
}

extension UIApplication {
  var topViewController: UIViewController? {
    guard let scene = connectedScenes.first as? UIWindowScene,
          let root = scene.keyWindow?.rootViewController else { return nil }
    var top = root
    while let p = top.presentedViewController { top = p }
    return top
  }
}
extension UIWindowScene { var keyWindow: UIWindow? { windows.first { $0.isKeyWindow } } }

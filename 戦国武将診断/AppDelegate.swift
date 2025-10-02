import UIKit
import GoogleMobileAds

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        let appID = Bundle.main.object(forInfoDictionaryKey: "GADApplicationIdentifier") as? String
        print("[Ads] AppID:", appID ?? "nil")
        guard let appID, !appID.isEmpty else {
            print("[Ads][WARN] GADApplicationIdentifier が見つかりません。広告は無効化します。")
            return true
        }
        DispatchQueue.main.async {
            print("[Ads] Initializing GoogleMobileAds on MAIN")
            MobileAds.shared.start { _ in
                print("[Ads] GoogleMobileAds started")
                AdsManager.shared.preload() // ← start完了後にだけ呼ぶ
            }
        }
        return true
    }
}

import UIKit
import GoogleMobileAds

final class AppDelegate: NSObject, UIApplicationDelegate {
    private static var didStartSDK = false

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        let appID = Bundle.main.object(forInfoDictionaryKey: "GADApplicationIdentifier") as? String
        print("[Ads] AppID in Info.plist:", appID ?? "nil")

        if appID == nil || appID?.isEmpty == true {
            print("[Ads][FATAL] GADApplicationIdentifier missing -> Ads disabled (no crash)")
            return true
        }

        if Self.didStartSDK {
            print("[Ads] SDK already started (skip)")
            return true
        }

        DispatchQueue.main.async {
            print("[Ads] Initializing GoogleMobileAds on MAIN")
            MobileAds.shared.start { status in
                print("[Ads] GoogleMobileAds started - status:", status.adapterStatusesByClassName.keys.joined(separator: ", "))
                AdsManager.isSDKStarted = true
                AdsManager.shared.preload()
            }
        }
        Self.didStartSDK = true
        return true
    }
}

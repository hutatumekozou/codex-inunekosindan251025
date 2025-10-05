import UIKit
import GoogleMobileAds

final class AppDelegate: NSObject, UIApplicationDelegate {
  private static var didStart = false

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

    if !AdsConfig.adsEnabled {
      Log.ads("disabled by AdsConfig=false"); return true
    }
    let appID = Bundle.main.object(forInfoDictionaryKey: "GADApplicationIdentifier") as? String
    Log.ads("AppID:", appID ?? "nil")
    guard let appID, !appID.isEmpty else {
      Log.ads("[WARN] AppID missing -> skip ads (no crash)"); return true
    }
    guard !Self.didStart else { Log.ads("SDK already started"); return true }

    // 同期的に初期化（メインスレッドで実行）
    Log.ads("Initializing GoogleMobileAds on MAIN (sync)")
    let gma = MobileAds.shared
    #if DEBUG
    if let id = ProcessInfo.processInfo.environment["GAD_TEST_DEVICE_ID"], !id.isEmpty {
      gma.requestConfiguration.testDeviceIdentifiers = [id]
      Log.ads("TestDevice:", id)
    }
    #endif

    gma.start { status in
      Log.ads("GoogleMobileAds started:", status.description)
      AdsManager.isSDKStarted = true
      // preloadは次のrunloopで実行
      DispatchQueue.main.async {
        AdsManager.shared.preload()
      }
    }

    Self.didStart = true
    return true
  }
}

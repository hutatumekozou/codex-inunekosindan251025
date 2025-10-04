import Foundation
enum AdsConfig {
  static var adsEnabled: Bool {
    get { UserDefaults.standard.object(forKey: "adsEnabled") as? Bool ?? true }
    set { UserDefaults.standard.set(newValue, forKey: "adsEnabled") }
  }
}
enum Log { static func ads(_ items: Any...) { print("[Ads]", items.map { "\($0)" }.joined(separator: " ")) } }

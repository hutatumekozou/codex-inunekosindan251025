import SwiftUI

func catalogBaseNamesInBundle() -> [String] {
    // 例: Assets.car, AppAssets.car などを検出して ["Assets", "AppAssets"] を返す
    guard let url = Bundle.main.resourceURL,
          let files = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil) else {
        return []
    }
    return files.compactMap { $0.pathExtension == "car" ? $0.deletingPathExtension().lastPathComponent : nil }
}

extension Image {
    /// カタログ名あり/なし双方で読み込みを試す。
    /// 例) name="hideyoshi" -> "hideyoshi", "Assets/hideyoshi", "AppAssets/hideyoshi"
    static func resolve(_ name: String) -> Image? {
        // 1) まず素の名前
        #if canImport(UIKit)
        if UIImage(named: name) != nil {
            print("[IMG] loaded directly:", name)
            return Image(name)
        }
        #endif

        // 2) .car から推定したカタログ名との組み合わせを試す
        let bases = catalogBaseNamesInBundle()
        for base in bases {
            let compound = "\(base)/\(name)"
            #if canImport(UIKit)
            if UIImage(named: compound) != nil {
                print("[IMG] loaded via namespaced asset:", compound)
                return Image(compound)
            }
            #endif
        }

        print("[IMG][MISS] not found:", name, " candidates:", bases.map { "\($0)/\(name)" })
        return nil
    }
}
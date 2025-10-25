// MARK: Image 安全ラッパ
import SwiftUI

extension Image {
    static func fromAssets(_ name: String) -> Image? {
        #if canImport(UIKit)
        if let ui = UIImage(named: name) {
            return Image(uiImage: ui)
        }
        #endif
        return nil
    }

    // 既存コード互換用のエイリアス
    static func dc_fromAssets(_ name: String) -> Image? {
        fromAssets(name)
    }
}

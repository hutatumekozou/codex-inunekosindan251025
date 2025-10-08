import SwiftUI

struct DogCatStartView: View {
    var startAction: () -> Void

    // 画像内ボタンの相対位置・サイズ（0.0〜1.0）
    private let buttonCenter = CGPoint(x: 0.5, y: 0.73)   // 横方向中央、やや下
    private let buttonRadiusW: CGFloat = 0.22             // 画像幅に対する半径

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // 背景色（画像余白の色）
                Color(red: 1.0, green: 0.965, blue: 0.917) // #FFF6EA
                    .ignoresSafeArea()

                // 画像そのまま（等比フィット）
                FittedImage(name: "DogCatStartFull")
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped() // scaledToFit と同等（トリミングは発生しない）

                // 透明ボタン（画像の"実表示矩形"に対して相対配置）
                TouchOverlay(
                    containerSize: geo.size,
                    imageAspect: FittedImage.aspect(of: "DogCatStartFull"),
                    center: buttonCenter,
                    radiusW: buttonRadiusW,
                    action: startAction
                )
            }
        }
    }
}

private struct FittedImage: View {
    let name: String
    var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()       // 等比・全体が収まる。トリミングや歪みなし
            .accessibilityHidden(true)
    }

    // 実用上のアスペクト比（画像サイズが取得できないため固定比）
    // 添付デザインの縦横比に近い値を使う。必要なら微調整。
    static func aspect(of _: String) -> CGFloat {
        // 例: 1080x1920 相当 → 1080/1920 = 0.5625（横/縦）
        // 添付に近い比率に調整（おおよそスマホ縦長 9:19.5）
        return 1080.0 / 1920.0
    }
}

/// 画像を scaledToFit で描画したときの「画像の実表示矩形」を計算し、
/// その中の相対座標(0〜1)に透明の丸ボタンを置く。
private struct TouchOverlay: View {
    let containerSize: CGSize
    let imageAspect: CGFloat   // width/height
    let center: CGPoint        // 0〜1
    let radiusW: CGFloat       // 画像幅に対する半径（0〜1）
    let action: () -> Void

    var body: some View {
        let containerAspect = containerSize.width / max(containerSize.height, 1)

        // scaledToFit: コンテナに完全収まるように等比拡縮
        // 画像が「横に細い」→ 高さ基準で合わせ、左右に余白
        // 画像が「縦に細い」→ 幅基準で合わせ、上下に余白
        let imageWidth: CGFloat
        let imageHeight: CGFloat
        let originX: CGFloat
        let originY: CGFloat

        if imageAspect < containerAspect {
            // コンテナの方が横長 → 高さを合わせる
            imageHeight = containerSize.height
            imageWidth = imageHeight * imageAspect
            originX = (containerSize.width - imageWidth) / 2.0
            originY = 0
        } else {
            // コンテナの方が縦長 → 幅を合わせる
            imageWidth = containerSize.width
            imageHeight = imageWidth / imageAspect
            originX = 0
            originY = (containerSize.height - imageHeight) / 2.0
        }

        // 画像内相対座標 → 実座標
        let cx = originX + imageWidth * center.x
        let cy = originY + imageHeight * center.y
        let r  = imageWidth * radiusW

        return AnyView(
            Button(action: {
                print("[TouchOverlay] Button tapped at (\(cx), \(cy)), radius: \(r)")
                action()
            }) {
                // 視覚的には何も置かない（デバッグ時は .stroke で可視化可）
                Circle().fill(Color.clear)
            }
            .frame(width: r*2, height: r*2)
            .contentShape(Circle())
            .position(x: cx, y: cy)
            // 誤タップ防止：ボタン外はヒット無効
        )
    }
}

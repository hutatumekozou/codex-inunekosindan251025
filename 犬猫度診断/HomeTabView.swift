// MARK: - NavigationView はここだけ（単一統一）
import SwiftUI

struct HomeTabView: View {
    init() {
        // 起動時に .car 検出ログを出す
        print("[IMG] asset catalogs in bundle:", catalogBaseNamesInBundle())
    }

    var body: some View {
        NavigationView {
            HomeScreen()
                .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
// MARK: - NavigationView はここだけ（単一統一）
import SwiftUI

struct HomeTabView: View {
    var body: some View {
        NavigationView {
            HomeScreen()
                .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
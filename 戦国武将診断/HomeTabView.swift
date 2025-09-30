import SwiftUI

struct HomeTabView: View {
    @StateObject private var router = AppRouter()
    @StateObject private var vm = QuizViewModel()

    init() {
        // 起動時に .car 検出ログを出す
        print("[IMG] asset catalogs in bundle:", catalogBaseNamesInBundle())
    }

    var body: some View {
        NavigationView {
            Group {
                switch router.currentScreen {
                case .home:
                    TabView {
                        HomeScreen(startAction: {
                            vm.load()
                            router.goQuiz()
                        })
                        .tabItem {
                            Label("HOME", systemImage: "house.fill")
                        }

                        AboutScreen()
                        .tabItem {
                            Label("このアプリについて", systemImage: "info.bubble")
                        }
                    }

                case .quiz:
                    QuizScreen(vm: vm) { result in
                        router.goResult(result)
                    }

                case .result(let r):
                    ResultScreen(result: r) {
                        router.reset()
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
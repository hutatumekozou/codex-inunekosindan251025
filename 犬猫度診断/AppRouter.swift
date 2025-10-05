import SwiftUI

enum AppScreen {
    case home
    case quiz
    case result(EvalResult)
}

final class AppRouter: ObservableObject {
    @Published var currentScreen: AppScreen = .home

    func goQuiz() {
        currentScreen = .quiz
    }

    func goResult(_ r: EvalResult) {
        currentScreen = .result(r)
    }

    func reset() {
        currentScreen = .home
    }
}
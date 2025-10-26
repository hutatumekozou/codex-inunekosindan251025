import Foundation

struct DogChoice: Identifiable, Hashable {
    let id = UUID()
    let key: String
    let text: String
    let score: Int
}

struct DogQuestion: Identifiable {
    let id: Int
    let text: String
    let choices: [DogChoice]
}

enum DogType: String, CaseIterable {
    case golden
    case labrador
    case toyPoodle
    case beagle
    case corgi
    case shiba
    case italianGreyhound
}

struct DogResultTemplate {
    let title: String
    let subtitle: String
    let description: String
    let tips: String
}

struct DogResultSummary: Identifiable {
    let id = UUID()
    let total: Int
    let type: DogType
}

import Foundation

final class CompatRepository {
    private static func candidates(_ name: String) -> [URL] {
        var urls: [URL] = []
        if let r = Bundle.main.resourceURL {
            urls += [r.appendingPathComponent("assessments/\(name)"),
                     r.appendingPathComponent("Resources/assessments/\(name)")]
        }
        if let u = Bundle.main.url(forResource: (name as NSString).deletingPathExtension,
                                   withExtension: (name as NSString).pathExtension) { urls.append(u) }
        #if DEBUG
        if let base = Bundle.main.resourceURL,
           let items = try? FileManager.default.subpathsOfDirectory(atPath: base.path),
           let hit = items.first(where: { $0.hasSuffix("/"+name) || $0 == name }) {
            urls.append(base.appendingPathComponent(hit))
        }
        #endif
        return urls
    }
    private static func decode<T:Decodable>(_ url: URL, as type: T.Type) -> T? {
        (try? Data(contentsOf: url)).flatMap { try? JSONDecoder().decode(T.self, from: $0) }
    }
    static func loadCompat(_ name: String) -> CompatDoc {
        for u in candidates(name) { if let d: CompatDoc = decode(u, as: CompatDoc.self) {
            print("[Repo] compat:", u.lastPathComponent, "questions=\(d.questions.count)"); return d } }
        fatalError("[Repo] compat JSON not found: \(name)")
    }
    static func loadPairProfiles(_ name: String) -> PairProfilesDoc {
        for u in candidates(name) { if let d: PairProfilesDoc = decode(u, as: PairProfilesDoc.self) {
            print("[Repo] pairs :", u.lastPathComponent, "profiles=\(d.profiles.count)"); return d } }
        fatalError("[Repo] pair-profiles JSON not found: \(name)")
    }
}

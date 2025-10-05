import Foundation

struct EvalResult {
    let profile: Profile
    let traitScores: [String:Int]
    let total: Int
}

final class AssessmentEvaluator {

    // キャリブレーション読み込み（traitScale + profileBonus）
    private static func loadCalibration() -> (traitScale: [String: Double], profileBonus: [String: Double]) {
        let candidates = [
            Bundle.main.resourceURL?.appendingPathComponent("assessments/diag_sengoku_calibration.json"),
            Bundle.main.resourceURL?.appendingPathComponent("Resources/assessments/diag_sengoku_calibration.json")
        ].compactMap{$0}
        for url in candidates {
            if let data = try? Data(contentsOf: url),
               let j = try? JSONSerialization.jsonObject(with: data) as? [String:Any] {
                let ts = j["traitScale"] as? [String:Double] ?? [:]
                let pb = j["profileBonus"] as? [String:Double] ?? [:]
                print("[Eval] calibration loaded:", url.lastPathComponent, "traitScale=\(ts.count), profileBonus=\(pb.count)")
                return (ts, pb)
            }
        }
        return ([:], [:])
    }

    static func evaluate(answers: [String:Choice], doc: AssessmentDoc, profiles: ProfilesDoc) -> EvalResult? {
        var traits = Dictionary(uniqueKeysWithValues: doc.meta.traits.map{ ($0, 0) })

        for (_, ch) in answers {
            for (k,v) in ch.weights {
                traits[k, default: 0] += v
            }
        }

        let calib = loadCalibration()
        let scales = calib.traitScale
        let bonuses = calib.profileBonus

        func score(_ formula: String) -> Int {
            let expr = formula.replacingOccurrences(of: " ", with: "")
            return expr.split(separator: "+").reduce(0) { acc, term in
                if term.contains("*") {
                    let parts = term.split(separator:"*")
                    let coef = Int(parts[0]) ?? 1
                    let key  = String(parts[1])
                    let base = traits[key] ?? 0
                    let mul  = scales[key] ?? 1.0
                    return acc + Int(Double(coef * base) * mul)
                } else {
                    let key = String(term)
                    let base = traits[key] ?? 0
                    let mul  = scales[key] ?? 1.0
                    return acc + Int(Double(base) * mul)
                }
            }
        }

        var bests: [(Profile, Int)] = []
        var bestV = Int.min
        for p in profiles.profiles {
            var s = score(p.formula)
            // プロファイル別ボーナス（加点。整数化しやすく10倍）
            let bonus = Int(round((bonuses[p.id] ?? 0.0) * 10.0))
            s += bonus
            if s > bestV { bestV = s; bests = [(p, s)] }
            else if s == bestV { bests.append((p, s)) }
        }
        // ランダム選出（同点）
        guard let chosen = bests.randomElement()?.0 else { return nil }
        return EvalResult(profile: chosen, traitScores: traits, total: bestV)
    }
}
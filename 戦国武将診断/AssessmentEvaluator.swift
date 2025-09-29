import Foundation

struct EvalResult {
    let profile: Profile
    let traitScores: [String:Int]
    let total: Int
}

final class AssessmentEvaluator {
    static func evaluate(answers: [String:Choice], doc: AssessmentDoc, profiles: ProfilesDoc) -> EvalResult? {
        var traits = Dictionary(uniqueKeysWithValues: doc.meta.traits.map{ ($0, 0) })

        for (_, ch) in answers {
            for (k,v) in ch.weights {
                traits[k, default: 0] += v
            }
        }

        func score(_ formula: String) -> Int {
            // very simple parser: "3*I + 2*A + 1*S"
            let parts = formula.replacingOccurrences(of: " ", with: "").split(separator: "+")
            return parts.reduce(0) { acc, term in
                if let mul = term.split(separator:"*").first, let coef = Int(mul),
                   let key = term.split(separator:"*").last {
                    return acc + coef * (traits[String(key)] ?? 0)
                }
                return acc + (traits[String(term)] ?? 0)
            }
        }

        var best: (Profile, Int)? = nil
        for p in profiles.profiles {
            let s = score(p.formula)
            if best == nil || s > best!.1 {
                best = (p, s)
            } else if let b = best, s == b.1 {
                // tie-break by highest trait order
                for t in doc.meta.tiebreak {
                    let bt = traits[t] ?? 0
                    let pt = traits[t] ?? 0
                    if pt > bt {
                        best = (p, s)
                        break
                    }
                    if pt < bt { break }
                }
            }
        }

        guard let res = best else { return nil }
        return EvalResult(profile: res.0, traitScores: traits, total: res.1)
    }
}
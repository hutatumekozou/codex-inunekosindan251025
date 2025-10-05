import Foundation

struct CompatResult { let pairProfile: PairProfile; let scorePercent: Int; let traitsA: [String:Int]; let traitsB: [String:Int] }

private func loadCalib() -> (traitScale:[String:Double], pairBonus:[String:Double], simW:Double, compW:Double, perTrait:[String:Double]) {
    let cands = [Bundle.main.resourceURL?.appendingPathComponent("assessments/compat_calibration.json"),
                 Bundle.main.resourceURL?.appendingPathComponent("Resources/assessments/compat_calibration.json")].compactMap{$0}
    for u in cands {
        if let d = try? Data(contentsOf: u),
           let j = try? JSONSerialization.jsonObject(with: d) as? [String:Any] {
            let ts = j["traitScale"] as? [String:Double] ?? [:]
            let pb = j["pairBonus"]  as? [String:Double] ?? [:]
            let sw = j["simWeight"]  as? Double ?? 0.6
            let cw = j["compWeight"] as? Double ?? 0.4
            let pt = j["perTraitWeight"] as? [String:Double] ?? [:]
            print("[Calib] loaded:", u.lastPathComponent)
            return (ts,pb,sw,cw,pt)
        }
    }
    return ([:],[:],0.6,0.4,[:])
}

private func cosine(_ a:[String:Double], _ b:[String:Double]) -> Double {
    var dot=0.0, na=0.0, nb=0.0
    for (k,va) in a { let vb=b[k] ?? 0; dot+=va*vb; na+=va*va }
    for (_,vb) in b { nb+=vb*vb }
    if na==0 || nb==0 { return 0 }
    return max(0, min(1, dot / (sqrt(na)*sqrt(nb))))
}
private func complementarity(_ a:[String:Double], _ b:[String:Double], w:[String:Double]) -> Double {
    let keys = Set(a.keys).union(b.keys)
    if keys.isEmpty { return 0 }
    var num=0.0, den=0.0
    for k in keys {
        let ww = w[k] ?? 1.0
        let ak=a[k] ?? 0, bk=b[k] ?? 0
        num += ww * abs(ak-bk)
        den += ww * max(max(ak,bk), 1.0)
    }
    if den==0 { return 0 }
    return max(0, 1.0 - min(1.0, num/den))
}

final class CompatEvaluator {
    static func evaluate(ansA:[String:CompatChoice], ansB:[String:CompatChoice], doc: CompatDoc, pairs: PairProfilesDoc) -> CompatResult {
        // 1) スコア化（件数はdoc.questions.countに自動追随）
        var A = Dictionary(uniqueKeysWithValues: doc.meta.traits.map{ ($0,0) })
        var B = A
        for (_,c) in ansA { for (k,v) in c.weights { A[k, default:0] += v } }
        for (_,c) in ansB { for (k,v) in c.weights { B[k, default:0] += v } }

        // 2) キャリブ適用
        let calib = loadCalib()
        let Ad = Dictionary(uniqueKeysWithValues: A.map { (k, v) in (k, Double(v) * (calib.traitScale[k] ?? 1.0)) })
        let Bd = Dictionary(uniqueKeysWithValues: B.map { (k, v) in (k, Double(v) * (calib.traitScale[k] ?? 1.0)) })
        let base = calib.simW * cosine(Ad,Bd) + calib.compW * complementarity(Ad,Bd, w: calib.perTrait)

        // 3) ペアタイプ決定（ボーナス & 同点ランダム）
        var bests:[(PairProfile,Double)] = []; var best = -1.0
        for p in pairs.profiles {
            let v = base + (calib.pairBonus[p.id] ?? 0.0)
            if v > best { best = v; bests = [(p,v)] }
            else if v == best { bests.append((p,v)) }
        }
        guard let chosen = bests.randomElement()?.0 else { fatalError("no pair profile") }
        let percent = Int(round(max(0,min(1,base))*100))
        return CompatResult(pairProfile: chosen, scorePercent: percent, traitsA: A, traitsB: B)
    }
}

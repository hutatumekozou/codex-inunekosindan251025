import Foundation

enum RepoError: Error { case notFound }

final class AssessmentRepository {
    static func loadQuestions(name: String) -> AssessmentDoc {
        for base in bases() {
            let url = base.appendingPathComponent(name)
            if let data = try? Data(contentsOf: url),
               let doc = try? JSONDecoder().decode(AssessmentDoc.self, from: data),
               doc.questions.count >= 1 {
                return doc
            }
        }
        print("[Repo] fallback questions used")
        return fallbackQuestions()
    }

    static func loadProfiles(name: String) -> ProfilesDoc {
        for base in bases() {
            let url = base.appendingPathComponent(name)
            if let data = try? Data(contentsOf: url),
               let doc = try? JSONDecoder().decode(ProfilesDoc.self, from: data),
               doc.profiles.count >= 1 {
                return doc
            }
        }
        print("[Repo] fallback profiles used")
        return fallbackProfiles()
    }

    private static func bases() -> [URL] {
        [
            Bundle.main.resourceURL?.appendingPathComponent("assessments"),
            Bundle.main.resourceURL?.appendingPathComponent("Resources/assessments")
        ].compactMap{$0}
    }
}

// MARK: - Fallback Data
extension AssessmentRepository {
    static func fallbackQuestions() -> AssessmentDoc {
        AssessmentDoc(
            version: "1.0",
            meta: AssessmentMeta(
                title: "戦国武将診断",
                traits: ["I","A","P","L","J","S","C"],
                tiebreak: ["I","S","C","P","A","L","J"]
            ),
            questions: [
                Question(
                    id: "q1",
                    text: "重要プロジェクトの初動は？",
                    choices: [
                        Choice(key: "A", text: "型破りな案を試す", weights: ["I":2,"C":1]),
                        Choice(key: "B", text: "布陣を先に固める", weights: ["S":2,"P":1]),
                        Choice(key: "C", text: "人を巻き込んで走る", weights: ["C":2,"A":1]),
                        Choice(key: "D", text: "情報を集めて腰を据える", weights: ["P":2,"S":1])
                    ]
                ),
                Question(
                    id: "q2",
                    text: "締切が迫ると？",
                    choices: [
                        Choice(key: "A", text: "ギア上げて攻める", weights: ["A":2,"I":1]),
                        Choice(key: "B", text: "計画に沿って粛々", weights: ["P":2]),
                        Choice(key: "C", text: "最適配置で回す", weights: ["S":2,"C":1]),
                        Choice(key: "D", text: "要件を絞り込む", weights: ["S":1,"P":1])
                    ]
                ),
                Question(
                    id: "q3",
                    text: "仲間が失敗したら？",
                    choices: [
                        Choice(key: "A", text: "次の打ち手を一緒に設計", weights: ["S":1,"P":1]),
                        Choice(key: "B", text: "役割を付け替えて再挑戦", weights: ["C":1,"S":1]),
                        Choice(key: "C", text: "自分が前に出て巻き返す", weights: ["A":1,"C":1]),
                        Choice(key: "D", text: "筋を示しつつ庇う", weights: ["L":1,"J":1])
                    ]
                )
            ],
            scoring: ["mode": "linear_sum"]
        )
    }

    static func fallbackProfiles() -> ProfilesDoc {
        ProfilesDoc(
            version: "1.0",
            meta: ["title": "戦国武将診断・結果"],
            profiles: [
                Profile(id: "nobunaga", name: "織田信長", formula: "3*I + 2*A + 2*C + 1*S",
                       summary: "革新と突破力で道を切り開くタイプ。常識に縛られず最短で勝ち筋へ。周囲は変化の速度について来られるよう役割を明確にすると◎。",
                       tips: ["今日の一手：大胆な新案をひとつ実験","相性：スピード感のある同盟"]),
                Profile(id: "hideyoshi", name: "豊臣秀吉", formula: "3*C + 2*A + 1*S + 1*L",
                       summary: "人を動かす天才。場を温め、機を見て伸ばす。小さく始めても巻き込み力で一気に拡大。感謝と再投資で運気が続く。",
                       tips: ["今日の一手：協力者に小さな役割を付与","相性：コミュ強の調整役"]),
                Profile(id: "ieyasu", name: "徳川家康", formula: "3*P + 2*S + 1*J",
                       summary: "長期戦の名手。準備と布陣で負けない土台を築く。焦らず機を待つことで最大効率に。節度と信頼が最大の武器。",
                       tips: ["今日の一手：撤退ラインを先に決める","相性：継続力のある参謀"]),
                Profile(id: "yukimura", name: "真田幸村", formula: "3*L + 1*C + 1*A",
                       summary: "義に厚い勇気の人。劣勢でも胆力と工夫でチャンスを掴む。仲間を守る姿勢が周囲の心を燃やす。",
                       tips: ["今日の一手：小勝を積み士気を上げる","相性：献身型の相棒"]),
                Profile(id: "kenshin", name: "上杉謙信", formula: "3*J + 2*L + 1*S",
                       summary: "義と清廉さで敬意を集める将。正道を貫くほど支持が強まる。筋を通しつつ柔らかい言葉を添えると調和が増す。",
                       tips: ["今日の一手：規範を一行で示す","相性：実直な実務家"]),
                Profile(id: "shingen", name: "武田信玄", formula: "3*S + 1*A + 1*P",
                       summary: "地形・補給・速度を読む達人。勝てる布陣で確実に制す。情報線と連携を厚くすると盤石。",
                       tips: ["今日の一手：補給と退路の再点検","相性：機を見るに敏な斥候"]),
                Profile(id: "masamune", name: "伊達政宗", formula: "2*C + 2*I + 1*A + 1*S",
                       summary: "個性と先見で魅せる開拓者。美意識とビジョンで周囲を惹きつける。独創と現実解のバランスが鍵。",
                       tips: ["今日の一手：ビジョンを一枚に可視化","相性：実装力の高い右腕"]),
                Profile(id: "motonari", name: "毛利元就", formula: "2*S + 2*P + 1*J",
                       summary: "分業とネットワークの名匠。小勢でも結束で大を制す。分断を避け、役割最適化が得意。",
                       tips: ["今日の一手：担当と期限を明文化","相性：調整型のハブ人材"])
            ]
        )
    }
}
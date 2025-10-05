import Foundation

struct DogCatScoringEngine {
    static func summarize(dog: Int, cat: Int) -> ScoreSummary {
        let total = max(dog + cat, 1)
        var dogPct = Int(round(Double(dog) / Double(total) * 100.0))
        var catPct = 100 - dogPct

        // 端数補正（例：四捨五入で101/99になるのを避ける）
        if dogPct + catPct != 100 {
            dogPct = min(max(dogPct, 0), 100)
            catPct = 100 - dogPct
        }

        let tier: DogCatTier
        if dogPct == 50 { tier = .fiftyFifty }
        else if dogPct >= 90 { tier = .superDog }
        else if dogPct >= 75 { tier = .dogStrong }
        else if dogPct >= 60 { tier = .dogLight }
        else if dogPct >= 40 { tier = .catLight }
        else if dogPct >= 25 { tier = .catStrong }
        else { tier = .superCat }

        return ScoreSummary(dogPoints: dog, catPoints: cat, dogPercent: dogPct, catPercent: catPct, tier: tier)
    }

    static func profile(for tier: DogCatTier) -> ResultProfile {
        switch tier {
        case .superDog:
            return ResultProfile(
                title: "超ドッグ",
                subtitle: "陽気で忠実、みんなのムードメーカー",
                description: "社交性と一体感を何より大切にするタイプ。明るく場を温め、困っている人がいれば即サポート。勢いに任せすぎず休息と境界線を持つとさらに魅力が引き立ちます。",
                tips: "連絡の\"間\"を意識し、相手のペースにも配慮を。スケジュールに\"オフ時間\"を固定すると長続き。"
            )
        case .dogStrong:
            return ResultProfile(
                title: "ドッグ寄り（強）",
                subtitle: "頼れるまとめ役、チームで輝く",
                description: "人と協働しながら着実に前進。巻き込み力と誠実さのバランスが良いタイプ。時に一人時間でリセットできると、より安定した成果に繋がります。",
                tips: "密なコミュニケーションに\"確認の一呼吸\"を。小さな達成でも称賛を言葉にすると◎。"
            )
        case .dogLight:
            return ResultProfile(
                title: "ややドッグ",
                subtitle: "柔らかく社交的、空気を読んで動ける",
                description: "明るさと協調性を持ちつつ、過度に群れない心地よい距離感。役割が明確なとき特に力を発揮します。",
                tips: "参加と不参加の線引きを先に決めると消耗を防げる。朝のルーティンが推進力に。"
            )
        case .fiftyFifty:
            return ResultProfile(
                title: "ハイブリッド 50/50",
                subtitle: "犬と猫の良いとこ取り",
                description: "社交性とマイペースのバランスが絶妙。状況に応じて切り替えられる器用さが強み。チームでもソロでも成果を出せる万能型です。",
                tips: "\"今日は犬/猫で行く\"とモードを宣言すると意思決定が速くなる。"
            )
        case .catLight:
            return ResultProfile(
                title: "ややキャット",
                subtitle: "自律的で静かな集中力",
                description: "必要な関わりは丁寧にしつつ、基本は自分のペースで高品質に仕上げるタイプ。過度な干渉がない環境で力を発揮します。",
                tips: "在宅や静かな場所の確保を。こまめな進捗共有だけ意識すると誤解を防げる。"
            )
        case .catStrong:
            return ResultProfile(
                title: "キャット寄り（強）",
                subtitle: "自由と探究のソリスト",
                description: "深い没入と夜型ブーストで独創的なアウトプット。関わる相手を選ぶほど集中が増します。過負荷を避けるため境界線を明確に。",
                tips: "\"返答する時間帯\"を先に伝えると楽。音・光・温度など環境最適化に投資を。"
            )
        case .superCat:
            return ResultProfile(
                title: "超キャット",
                subtitle: "孤高のマイペース、芯の強さ",
                description: "完全に自分のリズムで動くタイプ。静けさの中で最大火力を出します。社会的接点は選択的に、少数精鋭で十分。",
                tips: "定期的に体内時計を整える\"リセット日\"を設けると体力・気力が安定。"
            )
        }
    }
}

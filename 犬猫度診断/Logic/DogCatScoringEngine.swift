// MARK: - 9段階スコアリング
import Foundation

struct DogCatScoringEngine {
    static func summarize(dog: Int, cat: Int) -> ScoreSummary {
        let total = max(dog + cat, 1)
        var dogPct = Int(round(Double(dog) / Double(total) * 100.0))
        dogPct = min(max(dogPct, 0), 100)
        let catPct = 100 - dogPct

        let t: DCTier9
        if dogPct == 100 { t = .dog100 }
        else if dogPct >= 81 { t = .dog81_99 }
        else if dogPct >= 66 { t = .dog66_80 }
        else if dogPct >= 51 { t = .dog51_65 }
        else if dogPct == 50 { t = .fifty50 }
        else if dogPct >= 35 { t = .cat51_65 }   // 犬35–49% = 猫51–65%
        else if dogPct >= 20 { t = .cat66_80 }   // 犬20–34% = 猫66–80%
        else if dogPct >= 1  { t = .cat81_99 }   // 犬1–19%  = 猫81–99%
        else { t = .cat100 }                     // 犬0% = 猫100%

        return ScoreSummary(dogPoints: dog, catPoints: cat, dogPercent: dogPct, catPercent: catPct, tier: t)
    }

    static func profile(for tier: DCTier9) -> ResultProfile {
        return dcTemplates9[tier]!
    }
}

// MARK: - 9段階テンプレート定義
let dcTemplates9: [DCTier9: ResultProfile] = [
    .dog100: ResultProfile(
        title: "究極ドッグ 100%",
        subtitle: "太陽みたいな牽引力",
        description: "場を明るくし、人を巻き込み続ける生粋のチームブースター。頼られるほど力を発揮。休む勇気を持てば長距離戦でも無敵。",
        tips: "予定に\"強制オフ\"を固定／リアクション薄い相手にも間を置いて配慮／感謝を言葉と行動で。"
    ),
    .dog81_99: ResultProfile(
        title: "ハイパードッグ",
        subtitle: "頼れるムードメーカー",
        description: "協働が得意で、調整力も高い。ガンガン進めつつ、時々ひとり時間でバッテリー回復できると安定感が段違い。",
        tips: "要件は先に箇条書き共有／相手の境界線を尊重／小さな成功をみんなで祝う。"
    ),
    .dog66_80: ResultProfile(
        title: "バランスドッグ",
        subtitle: "社交×段取りの実務派",
        description: "明るさと計画性のバランスが良い実行リーダー。役割が明確な時に特に強く、合意形成もスムーズ。",
        tips: "参加/不参加の線引きを先に宣言／朝のミニルーティンで加速。"
    ),
    .dog51_65: ResultProfile(
        title: "ライトドッグ",
        subtitle: "寄り添い上手なチームプレイヤー",
        description: "人と一緒が心地よいが、過密だと疲れやすい。適度な距離感を設計できれば長く心地よく成果を出せる。",
        tips: "ミーティングは短く目的先出し／休憩と通知ミュートの時間帯を共有。"
    ),
    .fifty50: ResultProfile(
        title: "ハイブリッド 50/50",
        subtitle: "切替の達人",
        description: "社交とマイペースを状況で自在に切替。多様なチームでの橋渡し役に最適。モード宣言で意思決定がさらに速くなる。",
        tips: "今日は犬/猫モードと宣言／期待値と連絡頻度を先に合意。"
    ),
    .cat51_65: ResultProfile(
        title: "ライトキャット",
        subtitle: "静かな集中と誠実さ",
        description: "自分のペースを大切にしつつ必要な関係は丁寧。作業環境が整うほど出力が安定。過干渉は苦手。",
        tips: "進捗共有の\"頻度だけ\"合意／静かな作業ブロックを死守。"
    ),
    .cat66_80: ResultProfile(
        title: "バランスキャット",
        subtitle: "没入×合理の職人肌",
        description: "深く考え、質で勝負するタイプ。相手を選び集中的に関わるほど成果が伸びる。会議は要点先出しが◎。",
        tips: "返信可能時間を明確化／非同期のドキュメントコミュニケーションを活用。"
    ),
    .cat81_99: ResultProfile(
        title: "ハイパーキャット",
        subtitle: "自由と独創のソリスト",
        description: "静けさの中で最大火力。こだわりを守ると品質が跳ねる。接点は少数精鋭でOK。雑音は徹底的に排除して吉。",
        tips: "会議は短く目的→結論→依頼／通知を整理し深夜の集中を確保。"
    ),
    .cat100: ResultProfile(
        title: "究極キャット 100%",
        subtitle: "孤高のマイペース",
        description: "完全に自分のリズムで動き、唯一無二の成果を生む。ルールは必要最低限でよいが、健康管理だけは仕組み化を。",
        tips: "タスクは非同期で受け取り・締切逆算／体内時計のリセット日を固定。"
    )
]

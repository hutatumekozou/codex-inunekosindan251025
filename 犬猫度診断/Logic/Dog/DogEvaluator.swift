import Foundation

func dogTotalScore(_ answers: [DogChoice]) -> Int {
    answers.reduce(0) { $0 + $1.score }
}

func dogType(for total: Int) -> DogType {
    switch total {
    case 75...80: return .golden
    case 67...74: return .labrador
    case 59...66: return .toyPoodle
    case 51...58: return .beagle
    case 43...50: return .corgi
    case 35...42: return .shiba
    default:      return .italianGreyhound
    }
}

let DogResultTexts: [DogType: DogResultTemplate] = [
    .golden: .init(
        title: "ゴールデン・レトリーバー",
        subtitle: "超陽キャ・場の太陽",
        description: "誰とでも輪を作り、困っている人を放っておけない。勢いと包容力で場に安心感を生むタイプ。人前で力を発揮でき、初動の推進力はピカイチ。休息の計画を少し足すと燃費がさらに向上。",
        tips: "進行役で真価。短い合図→役割配布→自由度確保で爆発力UP。"
    ),
    .labrador: .init(
        title: "ラブラドール・レトリーバー",
        subtitle: "社交×実直のバランス",
        description: "明るく頼れて協働が得意。情報共有と安全運転を両立できるチームプレイヤー。はじめは温かく、最後は確実にまとめる。役割を明確にすると長期で強い。",
        tips: "目的・締切・担当を先に固定。途中の共有はライトに。"
    ),
    .toyPoodle: .init(
        title: "トイ・プードル",
        subtitle: "人懐こさと器用さ",
        description: "学習スピードが速く、空気を和ませるムードメーカー。小さな工夫で成果を伸ばす器用さも◎。予定に“ご褒美タイム”を入れると集中が続く。",
        tips: "小目標と報酬でリズムを作ると成果最大化。"
    ),
    .beagle: .init(
        title: "ビーグル",
        subtitle: "群れ×冒険のハイブリッド",
        description: "自分の足で確かめる行動派。探索→共有の流れが得意。大枠のゴールを決めたら自由度を残すと機動力が光る。",
        tips: "KPIはゆるめ、試行回数を確保。発見はすぐ共有。"
    ),
    .corgi: .init(
        title: "ウェルシュ・コーギー",
        subtitle: "明るさと芯の強さ",
        description: "人好きだが、流されすぎないマイルールも大切。情報整理とテンポの良い進行が武器。境界線を明確にすると心地よく活躍。",
        tips: "ToDoは小分け＋締切。会議は短く情報は整然と。"
    ),
    .shiba: .init(
        title: "柴犬",
        subtitle: "自立×落ち着きの職人肌",
        description: "過度な干渉を避け、信頼関係ができるほど力を発揮。黙々と質を高めるタイプ。要点共有と深い任せ方で真価。",
        tips: "非同期共有＋静かな作業ブロックで集中が伸びる。"
    ),
    .italianGreyhound: .init(
        title: "イタリアン・グレーハウンド",
        subtitle: "静かな集中と繊細さ",
        description: "整った環境で最大出力。少人数や個別作業で冴えるタイプ。予定は余白多めで、朝夕のルーティンを守ると安定感UP。",
        tips: "連絡はまとめて・ノンストップ時間を確保。"
    )
]

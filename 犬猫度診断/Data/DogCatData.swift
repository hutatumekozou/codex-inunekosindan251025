import Foundation

let dogCatQuestions: [DogCatQuestion] = [
    DogCatQuestion(
        text: "初対面でのあなたの立ち振る舞いは？",
        choices: [
            DogCatChoice(text: "明るく笑顔で距離を縮める", dog: 2, cat: 0),
            DogCatChoice(text: "まずは丁寧に挨拶、相手を立てる", dog: 1, cat: 0),
            DogCatChoice(text: "様子を見ながら必要最低限で話す", dog: 0, cat: 1),
            DogCatChoice(text: "観察に徹してタイミングを待つ", dog: 0, cat: 2),
        ]
    ),
    DogCatQuestion(
        text: "休日の理想の過ごし方は？",
        choices: [
            DogCatChoice(text: "友だちと外でアクティブに", dog: 2, cat: 0),
            DogCatChoice(text: "誰かとゆるくランチ", dog: 1, cat: 0),
            DogCatChoice(text: "一人で好きなコンテンツに没頭", dog: 0, cat: 1),
            DogCatChoice(text: "完全ソロで静かな場所にこもる", dog: 0, cat: 2),
        ]
    ),
    DogCatQuestion(
        text: "連絡のスタイルに一番近いのは？",
        choices: [
            DogCatChoice(text: "即レスでテンポよく会話", dog: 2, cat: 0),
            DogCatChoice(text: "なるべく早めに返す", dog: 1, cat: 0),
            DogCatChoice(text: "気づいたら返す派", dog: 0, cat: 1),
            DogCatChoice(text: "まとめて返す or 既読スルーもある", dog: 0, cat: 2),
        ]
    ),
    DogCatQuestion(
        text: "仕事/課題の進め方は？",
        choices: [
            DogCatChoice(text: "チームで役割分担し一気に前進", dog: 2, cat: 0),
            DogCatChoice(text: "相談しつつ自分の担当をキッチリ", dog: 1, cat: 0),
            DogCatChoice(text: "基本は単独で集中して進める", dog: 0, cat: 1),
            DogCatChoice(text: "自分のペースで静かにやり切る", dog: 0, cat: 2),
        ]
    ),
    DogCatQuestion(
        text: "人からの期待に対して…",
        choices: [
            DogCatChoice(text: "応えたい！背中を預けてほしい", dog: 2, cat: 0),
            DogCatChoice(text: "できる範囲でしっかり応える", dog: 1, cat: 0),
            DogCatChoice(text: "過度な期待は少し負担に感じる", dog: 0, cat: 1),
            DogCatChoice(text: "期待より自分の心地よさ優先", dog: 0, cat: 2),
        ]
    ),
    DogCatQuestion(
        text: "集まりに誘われたら？",
        choices: [
            DogCatChoice(text: "基本参加！人といると元気が出る", dog: 2, cat: 0),
            DogCatChoice(text: "内容次第で前向きに検討", dog: 1, cat: 0),
            DogCatChoice(text: "少人数や気心知れた人だけ行く", dog: 0, cat: 1),
            DogCatChoice(text: "ほぼ不参加。自由時間が大事", dog: 0, cat: 2),
        ]
    ),
    DogCatQuestion(
        text: "理想の上司/先輩像は？",
        choices: [
            DogCatChoice(text: "明るく引っ張り頼れるリーダー", dog: 2, cat: 0),
            DogCatChoice(text: "背中で示す誠実なまとめ役", dog: 1, cat: 0),
            DogCatChoice(text: "放任で自由にさせてくれる人", dog: 0, cat: 1),
            DogCatChoice(text: "干渉せず成果だけ見てくれる人", dog: 0, cat: 2),
        ]
    ),
    DogCatQuestion(
        text: "スケジュール管理は？",
        choices: [
            DogCatChoice(text: "早起き＆朝活で前倒し", dog: 2, cat: 0),
            DogCatChoice(text: "計画通りコツコツ", dog: 1, cat: 0),
            DogCatChoice(text: "波に乗ると一気にやるタイプ", dog: 0, cat: 1),
            DogCatChoice(text: "夜型。締切直前の集中力に賭ける", dog: 0, cat: 2),
        ]
    ),
    DogCatQuestion(
        text: "褒められたら？",
        choices: [
            DogCatChoice(text: "嬉しくてもっと頑張りたくなる", dog: 2, cat: 0),
            DogCatChoice(text: "素直に受け取り淡々と次へ", dog: 1, cat: 0),
            DogCatChoice(text: "心の中でニヤッとする程度", dog: 0, cat: 1),
            DogCatChoice(text: "照れて流す/反射的に謙遜する", dog: 0, cat: 2),
        ]
    ),
    DogCatQuestion(
        text: "困っている人を見かけたら？",
        choices: [
            DogCatChoice(text: "即声かけ＆伴走サポート", dog: 2, cat: 0),
            DogCatChoice(text: "相手のペースを尊重して支援", dog: 1, cat: 0),
            DogCatChoice(text: "必要なら手短にフォロー", dog: 0, cat: 1),
            DogCatChoice(text: "原則見守り。助けを求められたら", dog: 0, cat: 2),
        ]
    ),
    DogCatQuestion(
        text: "好きな環境は？",
        choices: [
            DogCatChoice(text: "にぎやかで人の気配がある場所", dog: 2, cat: 0),
            DogCatChoice(text: "程よい雑談があるオフィス", dog: 1, cat: 0),
            DogCatChoice(text: "静かな自室や図書館", dog: 0, cat: 1),
            DogCatChoice(text: "誰にも会わない自然/夜更け", dog: 0, cat: 2),
        ]
    ),
    DogCatQuestion(
        text: "新しい挑戦に対しての姿勢は？",
        choices: [
            DogCatChoice(text: "まず飛び込んで学びながら進む", dog: 2, cat: 0),
            DogCatChoice(text: "準備してから前向きに挑戦", dog: 1, cat: 0),
            DogCatChoice(text: "必要性があればやる", dog: 0, cat: 1),
            DogCatChoice(text: "本当に自分が望む時だけ動く", dog: 0, cat: 2),
        ]
    ),
    DogCatQuestion(
        text: "SNSの使い方に近いのは？",
        choices: [
            DogCatChoice(text: "友だちとワイワイ交流", dog: 2, cat: 0),
            DogCatChoice(text: "情報収集＆時々発信", dog: 1, cat: 0),
            DogCatChoice(text: "見る専が多め", dog: 0, cat: 1),
            DogCatChoice(text: "ほぼ使わない/クローズド", dog: 0, cat: 2),
        ]
    ),
    DogCatQuestion(
        text: "頼られた時の本音は？",
        choices: [
            DogCatChoice(text: "任せて！役に立てるのが嬉しい", dog: 2, cat: 0),
            DogCatChoice(text: "できる範囲で力になりたい", dog: 1, cat: 0),
            DogCatChoice(text: "場合によっては距離を保ちたい", dog: 0, cat: 1),
            DogCatChoice(text: "基本は各自でやってほしい", dog: 0, cat: 2),
        ]
    ),
    DogCatQuestion(
        text: "マイルールと自由のバランスは？",
        choices: [
            DogCatChoice(text: "ルールがあると動きやすい", dog: 2, cat: 0),
            DogCatChoice(text: "最低限のルールがあればOK", dog: 1, cat: 0),
            DogCatChoice(text: "自由裁量が多い方が良い", dog: 0, cat: 1),
            DogCatChoice(text: "縛られず完全自由が理想", dog: 0, cat: 2),
        ]
    ),
    DogCatQuestion(
        text: "サプライズは好き？",
        choices: [
            DogCatChoice(text: "大好き！リアクション大きめ", dog: 2, cat: 0),
            DogCatChoice(text: "嬉しいけどほどほどで", dog: 1, cat: 0),
            DogCatChoice(text: "気持ちは嬉しいが疲れる", dog: 0, cat: 1),
            DogCatChoice(text: "事前に知りたい…心の準備が必要", dog: 0, cat: 2),
        ]
    ),
    DogCatQuestion(
        text: "居心地の良い人間関係は？",
        choices: [
            DogCatChoice(text: "なんでも話せる近い距離感", dog: 2, cat: 0),
            DogCatChoice(text: "適度に会って程よく交流", dog: 1, cat: 0),
            DogCatChoice(text: "必要な時だけ連絡", dog: 0, cat: 1),
            DogCatChoice(text: "基本は一人、数人と深く", dog: 0, cat: 2),
        ]
    ),
    DogCatQuestion(
        text: "クリエイティブ作業は？",
        choices: [
            DogCatChoice(text: "みんなの反応をもらいながら改善", dog: 2, cat: 0),
            DogCatChoice(text: "レビューをもらって微修正", dog: 1, cat: 0),
            DogCatChoice(text: "一度仕上げてから最小限の修正", dog: 0, cat: 1),
            DogCatChoice(text: "完全に一人で完結させたい", dog: 0, cat: 2),
        ]
    ),
    DogCatQuestion(
        text: "理想の住まいは？",
        choices: [
            DogCatChoice(text: "駅近で人の流れがある街", dog: 2, cat: 0),
            DogCatChoice(text: "住宅街で静かすぎない場所", dog: 1, cat: 0),
            DogCatChoice(text: "静かな下町や郊外", dog: 0, cat: 1),
            DogCatChoice(text: "自然豊かで誰にも会わない環境", dog: 0, cat: 2),
        ]
    ),
    DogCatQuestion(
        text: "あなたの\"癒やし\"は？",
        choices: [
            DogCatChoice(text: "仲間と笑って過ごす時間", dog: 2, cat: 0),
            DogCatChoice(text: "誰かと穏やかに会話", dog: 1, cat: 0),
            DogCatChoice(text: "一人で趣味に没頭", dog: 0, cat: 1),
            DogCatChoice(text: "静けさと完全オフライン", dog: 0, cat: 2),
        ]
    )
]

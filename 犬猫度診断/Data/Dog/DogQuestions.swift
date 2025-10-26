import Foundation

let DogQuestions: [DogQuestion] = [
    DogQuestion(id: 1, text: "初対面の集まりで最初にすることは？", choices: [
        .init(key: "A", text: "会話の輪を広げて場を温める", score: 4),
        .init(key: "B", text: "近くの人に自然に話しかける", score: 3),
        .init(key: "C", text: "様子を見つつ相槌中心で入る", score: 2),
        .init(key: "D", text: "挨拶だけして静かに観察する", score: 1)
    ]),
    DogQuestion(id: 2, text: "予定のない休日、あなたは？", choices: [
        .init(key: "A", text: "大人数でアウトドアを計画", score: 4),
        .init(key: "B", text: "数人でカフェや映画へ", score: 3),
        .init(key: "C", text: "一人で気分転換の散歩", score: 2),
        .init(key: "D", text: "家でじっくり趣味に没頭", score: 1)
    ]),
    DogQuestion(id: 3, text: "仕事/勉強のスタイルは？", choices: [
        .init(key: "A", text: "人とブレストしながら勢いで進める", score: 4),
        .init(key: "B", text: "相談しつつテンポ良く進める", score: 3),
        .init(key: "C", text: "まず自分で組み立ててから共有", score: 2),
        .init(key: "D", text: "一人で黙々と集中して仕上げる", score: 1)
    ]),
    DogQuestion(id: 4, text: "初めての場所でのランチ選びは？", choices: [
        .init(key: "A", text: "みんなを誘って人気店に突撃", score: 4),
        .init(key: "B", text: "口コミを見て数人で挑戦", score: 3),
        .init(key: "C", text: "行列を避けて静かな店へ", score: 2),
        .init(key: "D", text: "テイクアウトで落ち着いて食べる", score: 1)
    ]),
    DogQuestion(id: 5, text: "連絡手段の好みは？", choices: [
        .init(key: "A", text: "電話やVCでリアルタイム", score: 4),
        .init(key: "B", text: "音声メッセ＋テキスト併用", score: 3),
        .init(key: "C", text: "テキスト中心", score: 2),
        .init(key: "D", text: "必要最低限のみ", score: 1)
    ]),
    DogQuestion(id: 6, text: "サプライズの反応は？", choices: [
        .init(key: "A", text: "大歓迎！全力でのる", score: 4),
        .init(key: "B", text: "嬉しい、ほどよく楽しむ", score: 3),
        .init(key: "C", text: "事前に少し知りたい", score: 2),
        .init(key: "D", text: "予告なしは苦手", score: 1)
    ]),
    DogQuestion(id: 7, text: "パーティの居場所は？", choices: [
        .init(key: "A", text: "真ん中で仕切る/盛り上げる", score: 4),
        .init(key: "B", text: "複数のグループを渡り歩く", score: 3),
        .init(key: "C", text: "決まった友人と静かに話す", score: 2),
        .init(key: "D", text: "端のほうで落ち着く", score: 1)
    ]),
    DogQuestion(id: 8, text: "新しい趣味の始め方は？", choices: [
        .init(key: "A", text: "友達を巻き込みイベント参加", score: 4),
        .init(key: "B", text: "体験会や教室に行ってみる", score: 3),
        .init(key: "C", text: "一人で動画/本から始める", score: 2),
        .init(key: "D", text: "まずは観察期間を置く", score: 1)
    ]),
    DogQuestion(id: 9, text: "通勤・通学中の理想は？", choices: [
        .init(key: "A", text: "同僚/友人とおしゃべり", score: 4),
        .init(key: "B", text: "たまに会話、たまに一人時間", score: 3),
        .init(key: "C", text: "音楽/Podcastで自分時間", score: 2),
        .init(key: "D", text: "無音で静かに", score: 1)
    ]),
    DogQuestion(id: 10, text: "写真・SNSとの距離感は？", choices: [
        .init(key: "A", text: "皆で写真撮って即シェア", score: 4),
        .init(key: "B", text: "たまに楽しい場面を投稿", score: 3),
        .init(key: "C", text: "思い出用にひっそり保存", score: 2),
        .init(key: "D", text: "ほぼ使わない/非公開", score: 1)
    ]),
    DogQuestion(id: 11, text: "集中を乱すものへの耐性は？", choices: [
        .init(key: "A", text: "ノイズも人も気にせずやれる", score: 4),
        .init(key: "B", text: "イヤホンあればOK", score: 3),
        .init(key: "C", text: "できれば静かな場所で", score: 2),
        .init(key: "D", text: "完全静寂が最強", score: 1)
    ]),
    DogQuestion(id: 12, text: "旅行のスタイルは？", choices: [
        .init(key: "A", text: "大人数でわいわい計画少なめ", score: 4),
        .init(key: "B", text: "少人数で柔軟に観光", score: 3),
        .init(key: "C", text: "一人旅で丁寧に巡る", score: 2),
        .init(key: "D", text: "決めたルートを淡々と楽しむ", score: 1)
    ]),
    DogQuestion(id: 13, text: "トラブル時の動きは？", choices: [
        .init(key: "A", text: "皆に声をかけて即座に仕切る", score: 4),
        .init(key: "B", text: "役割分担して解決", score: 3),
        .init(key: "C", text: "自分の持ち場を静かに片付ける", score: 2),
        .init(key: "D", text: "状況を見極め最小限で対処", score: 1)
    ]),
    DogQuestion(id: 14, text: "仲良くなるスピード感は？", choices: [
        .init(key: "A", text: "すぐ打ち解けて友達に", score: 4),
        .init(key: "B", text: "数回会えば自然と", score: 3),
        .init(key: "C", text: "何度か時間をかけて", score: 2),
        .init(key: "D", text: "かなり時間が必要", score: 1)
    ]),
    DogQuestion(id: 15, text: "定例会議の理想時間は？", choices: [
        .init(key: "A", text: "長めでも活発議論が良い", score: 4),
        .init(key: "B", text: "必要時間＋雑談少し", score: 3),
        .init(key: "C", text: "コンパクトで要点だけ", score: 2),
        .init(key: "D", text: "非同期共有がベスト", score: 1)
    ]),
    DogQuestion(id: 16, text: "役割志向は？", choices: [
        .init(key: "A", text: "旗振り役/フロントが心地よい", score: 4),
        .init(key: "B", text: "サブリーダー/調整役が得意", score: 3),
        .init(key: "C", text: "職人枠で品質担保", score: 2),
        .init(key: "D", text: "研究/分析で裏方支援", score: 1)
    ]),
    DogQuestion(id: 17, text: "週末の理想の夜は？", choices: [
        .init(key: "A", text: "大人数でホームパーティ", score: 4),
        .init(key: "B", text: "仲良しで外食/宅飲み", score: 3),
        .init(key: "C", text: "自宅で少人数ボドゲ/映画", score: 2),
        .init(key: "D", text: "一人で読書/ゲーム/制作", score: 1)
    ]),
    DogQuestion(id: 18, text: "新しい人へのコンタクト頻度は？", choices: [
        .init(key: "A", text: "すぐ誘う/連絡する", score: 4),
        .init(key: "B", text: "用事＋雑談でつながる", score: 3),
        .init(key: "C", text: "必要時のみ丁寧に", score: 2),
        .init(key: "D", text: "基本受け身", score: 1)
    ]),
    DogQuestion(id: 19, text: "褒められたら？", choices: [
        .init(key: "A", text: "その場で皆に感謝を広げる", score: 4),
        .init(key: "B", text: "笑顔で礼、次の行動へ", score: 3),
        .init(key: "C", text: "静かに礼を述べる", score: 2),
        .init(key: "D", text: "照れて話題を変える", score: 1)
    ]),
    DogQuestion(id: 20, text: "予期せぬ予定変更が発生：", choices: [
        .init(key: "A", text: "すぐ代替案を皆に投げる", score: 4),
        .init(key: "B", text: "メンバーと相談して調整", score: 3),
        .init(key: "C", text: "まず自分の計画を組み替える", score: 2),
        .init(key: "D", text: "変更は最小限にして様子見", score: 1)
    ])
]

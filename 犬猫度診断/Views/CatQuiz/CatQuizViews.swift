import SwiftUI

enum CatType: String, CaseIterable {
    case bengal, abyssinian, siamese, americanShorthair, scottishFold, russianBlue, persian
    var displayName: String {
        switch self {
        case .bengal: return "ベンガル"
        case .abyssinian: return "アビシニアン"
        case .siamese: return "シャム"
        case .americanShorthair: return "アメリカンショートヘア"
        case .scottishFold: return "スコティッシュフォールド"
        case .russianBlue: return "ロシアンブルー"
        case .persian: return "ペルシャ"
        }
    }
}

struct CatQuestion {
    let text: String
    let options: [String]
}

struct CatQuizRootView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var idx = 0
    @State private var answers: [Character] = []
    @State private var finished = false
    var onClose: () -> Void = {}

    private let questions: [CatQuestion] = CatQuizData.questions

    private func resetAndClose() {
        onClose()
        dismiss()
    }

    var body: some View {
        VStack(spacing: 0) {
            if finished {
                CatResultView(answers: answers, onClose: resetAndClose)
            } else {
                CatQuestionView(
                    questionIndex: idx,
                    total: questions.count,
                    question: questions[idx],
                    onSelect: { ch in
                        answers.append(ch)
                        if idx + 1 < questions.count {
                            idx += 1
                        } else {
                            finished = true
                        }
                    }
                )
            }
        }
        .navigationTitle("あなたにピッタリのネコは")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct CatQuestionView: View {
    let questionIndex: Int
    let total: Int
    let question: CatQuestion
    let onSelect: (Character) -> Void

    var body: some View {
        ZStack {
            QuizBackground()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Q\(questionIndex+1)/\(total)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .accessibilityLabel("Question \(questionIndex + 1) of \(total)")

                    ProgressView(value: Double(questionIndex + 1), total: Double(total))
                        .progressViewStyle(.linear)
                        .tint(Color(#colorLiteral(red: 0.0, green: 0.42, blue: 1.0, alpha: 1)))
                        .accessibilityHidden(true)

                    Text(question.text)
                        .font(.title3).bold()
                        .padding(.top, 4)

                    ForEach(Array(question.options.enumerated()), id: \.offset) { i, text in
                        let tag: Character = ["A", "B", "C", "D"][i]
                        Button {
                            onSelect(tag)
                        } label: {
                            HStack {
                                Text(text).foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(14)
                            .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(.plain)
                    }

                    Spacer()
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .background(Color.clear)
            }
        }
    }
}

#Preview {
    CatQuestionView(
        questionIndex: 0,
        total: 20,
        question: CatQuestion(
            text: "初対面でのあなたの距離感は？",
            options: [
                "すぐフレンドリーに話す",
                "まず軽く雑談する",
                "相手の様子を見てから",
                "必要最低限だけ話す"
            ]
        ),
        onSelect: { _ in }
    )
}

struct CatResultView: View {
    let answers: [Character]
    var onClose: () -> Void = {}

    private let catResultImageName: [CatType: String] = [
        .bengal: "cat_bengal_photo",
        .abyssinian: "cat_result_abyssinian",
        .siamese: "cat_result_siamese",
        .americanShorthair: "cat_result_american_shorthair",
        .scottishFold: "cat_result_scottish_fold",
        .russianBlue: "cat_result_russian_blue",
        .persian: "cat_result_persian"
    ]

    private var sum: Int {
        answers.reduce(0) { partial, ch in
            switch ch {
            case "A": return partial + 4
            case "B": return partial + 3
            case "C": return partial + 2
            default:  return partial + 1
            }
        }
    }
    private var counts: (a: Int, b: Int, c: Int, d: Int) {
        (
            answers.filter { $0 == "A" }.count,
            answers.filter { $0 == "B" }.count,
            answers.filter { $0 == "C" }.count,
            answers.filter { $0 == "D" }.count
        )
    }
    private var type: CatType {
        CatQuizData.type(
            forSum: sum,
            countA: counts.a,
            countD: counts.d,
            countB: counts.b,
            countC: counts.c
        )
    }
    private var title: String { type.displayName }
    private var subtitle: String { CatQuizData.subtitle(for: type) }
    private var detail: String { CatQuizData.detail(for: type) }

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                if let imageName = catResultImageName[type] {
                    let resultImage = Image.dc_fromAssets(imageName) ?? Image.fromAssets(imageName)
                    (resultImage ?? Image(systemName: "pawprint"))
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 260)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 6)
                }

                Text(title).font(.largeTitle).bold()
                Text(subtitle).foregroundColor(.secondary)

                VStack(alignment: .leading, spacing: 12) {
                    Text("診断結果").font(.title3).bold()
                    Text(detail).fixedSize(horizontal: false, vertical: true)
                    Divider()
                    Text("相性のヒント").font(.title3).bold()
                    Text(CatQuizData.hint(for: type)).fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(16)

                Button {
                    AdsManager.shared.show {
                        onClose()
                    }
                } label: {
                    Label("HOMEに戻る", systemImage: "house.fill")
                        .font(.system(size: 17, weight: .semibold))
                        .padding(.vertical, 12)
                        .padding(.horizontal, 28)
                        .background(
                            Capsule()
                                .fill(Color(#colorLiteral(red: 0.0, green: 0.42, blue: 1.0, alpha: 1)))
                        )
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
                .padding(.top, 12)
            }
            .padding(20)
        }
    }
}

enum CatQuizData {
    static func extroversionPercent(from totalScore: Int) -> Int {
        let clamped = max(20, min(80, totalScore))
        let percent = Double(clamped - 20) / 60.0 * 100.0
        return Int(round(percent))
    }

    static func type(forSum sum: Int, countA: Int, countD: Int, countB: Int, countC: Int) -> CatType {
        catBreedFixedRange(from: sum)
    }

    private static func catBreedFixedRange(from totalScore: Int) -> CatType {
        let s = max(20, min(80, totalScore))
        switch s {
        case 74...80:
            return .bengal
        case 65...73:
            return .abyssinian
        case 56...64:
            return .siamese
        case 47...55:
            return .americanShorthair
        case 38...46:
            return .scottishFold
        case 29...37:
            return .russianBlue
        default:
            return .persian
        }
    }

    static let questions: [CatQuestion] = [
        .init(text: "初対面でのあなたの距離感は？",
              options: ["すぐフレンドリーに話す","まず軽く雑談する","相手の様子を見てから","必要最低限だけ話す"]),
        .init(text: "週末の理想は？",
              options: ["大人数でイベント","友人2–3人で外出","家で趣味＋たまに外出","一人で静かに過ごす"]),
        .init(text: "新しい場所に行くときは？",
              options: ["ノリで飛び込む","下調べ少しで行く","事前に結構調べる","慣れた場所が安心"]),
        .init(text: "チャットの通知は？",
              options: ["即返信が基本","早めに返す","まとめて返す","既読スルー多め"]),
        .init(text: "褒められた時の反応は？",
              options: ["全力で喜ぶ＆共有","ありがとう！と自然に","照れてサラっと","心の中で静かに"]),
        .init(text: "仕事/勉強の場での発言は？",
              options: ["先陣切って意見","タイミングを見て","促されたら話す","基本は聞き役"]),
        .init(text: "初めての趣味サークルなら？",
              options: ["その日から中心に","すぐ仲良くなる","少しずつ馴染む","まずは見学だけ"]),
        .init(text: "音楽の好みは？",
              options: ["フェス/クラブ系","ライブや流行曲","落ち着くポップ/ジャズ","アンビエント/静かな曲"]),
        .init(text: "写真の扱いは？",
              options: ["どんどんSNSに投稿","いい写真だけ投稿","限定公開で共有","ほぼ保存のみ"]),
        .init(text: "サプライズに対して？",
              options: ["大歓迎！自分も仕掛ける","されるのは嬉しい","小さめならOK","苦手、事前に知りたい"]),
        .init(text: "MTGの理想時間は？",
              options: ["長くても活発議論","必要なら長めでも","手短に要点だけ","メッセージで済ませたい"]),
        .init(text: "カフェで座る場所は？",
              options: ["出入口付近で賑やか","ほどよく人の流れ","端の落ち着く席","一番静かな隅"]),
        .init(text: "服装の傾向は？",
              options: ["目を引くトレンド","清潔感＋少し個性","ベーシック重視","機能性と落ち着き"]),
        .init(text: "グループ旅行の役回りは？",
              options: ["旗振りリーダー","ムードメーカー","サポートと調整","みんなに合わせる"]),
        .init(text: "知らない人からの連絡は？",
              options: ["すぐ返して広げる","内容次第ですぐ","時間が空いたら","基本スルー"]),
        .init(text: "ランチの決め方は？",
              options: ["新店・行列でも挑戦","評判の店に行く","定番が多い","いつもの一択"]),
        .init(text: "プレゼンや発表は？",
              options: ["むしろ好き","練習すれば大丈夫","出来れば避けたい","極力パス"]),
        .init(text: "予定変更が入ったら？",
              options: ["代替案をすぐ提案","みんなの意見をまとめる","いったん様子見","予定が崩れると疲れる"]),
        .init(text: "SNSフォロワーとの関係は？",
              options: ["オン/オフ混在で交流","オンライン中心に交流","限られた範囲で","見るだけ・閉じてる"]),
        .init(text: "一番リラックスする瞬間は？",
              options: ["仲間とワイワイ","友人とまったり","好きな作業に没頭","静かな一人時間"])
    ]

    static func subtitle(for type: CatType) -> String {
        switch type {
        case .bengal: return "超社交・運動家タイプ"
        case .abyssinian: return "明るい探究者タイプ"
        case .siamese: return "おしゃべり甘えん坊タイプ"
        case .americanShorthair: return "バランス型"
        case .scottishFold: return "穏やかマイペース"
        case .russianBlue: return "慎重で一途"
        case .persian: return "静穏スローライフ"
        }
    }

    static func detail(for type: CatType) -> String {
        switch type {
        case .bengal:
            return "冒険心と遊び心いっぱい。賑やかな場で才能が開花。最低限の計画で走りながら調整すると力を発揮。"
        case .abyssinian:
            return "好奇心と機動力で日常を軽やかにアップデート。小刻みに試して学ぶと良い流れに。"
        case .siamese:
            return "つながりが原動力。対話とフィードバックでモチベ安定。休憩を予定に組み込むと長続き。"
        case .americanShorthair:
            return "社交とマイペースの中庸。目的と手段をシンプルに整えると成果が出やすい。"
        case .scottishFold:
            return "自分のリズムを守るほど実力発揮。少数と深くつながると幸福度アップ。"
        case .russianBlue:
            return "観察力と質の追求が武器。ルーティン化と静かな集中時間で安定。"
        case .persian:
            return "落ち着きと上品さが魅力。環境を整え、予定は少なめ・深めが向く。"
        }
    }

    static func hint(for type: CatType) -> String {
        switch type {
        case .bengal:
            return "予定は8割＋即興の余白を。周囲を巻き込む役で輝く。"
        case .abyssinian:
            return "共有をこまめに。新しい挑戦は小さく速く回す。"
        case .siamese:
            return "人との時間と休息のバランスを可視化。"
        case .americanShorthair:
            return "やることを3点に絞って前進。"
        case .scottishFold:
            return "タスクは小分けに。無理な社交は不要。"
        case .russianBlue:
            return "事前告知とバッファで変化ストレスを軽減。"
        case .persian:
            return "音・香り・照明で環境最適化。"
        }
    }
}

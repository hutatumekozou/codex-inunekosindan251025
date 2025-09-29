# プロジェクトガイド（CLAUDE.md：診断アプリ用・最新版）

このファイルは Claude Code が本リポジトリで iOS（SwiftUI）の診断アプリを開発・改修するための作業指針です。以後の自動実装・修正・検証タスクは本ガイドに準拠してください。
**重要：Claude Code 上の作業報告・出力はすべて日本語で行うこと。**

## 1. プロジェクト概要（診断アプリ）

- **アプリ名**: APP_NAME（任意）
- **目的**: 質問に回答 → 選択肢ごとの重みづけで特性スコアを集計 → タイプ/キャラクターを判定して結果カードを表示。
- **最低対応OS**: iOS 15+
- **UI**: SwiftUI（必要に応じて UIKit 併用可）
- **広告**: Google Mobile Ads (AdMob)（任意／Debug と Release でIDを切替）
- **配布**: Xcode  → App Store Connect
- **除外**: Expo / React Native のルール非適用（Swiftネイティブ統一）

## 2. 開発ルール

- **命名**: Swift API Design Guidelines 準拠。略語は避け、意味が伝わる型名・メソッド名。
- **依存管理**: SPMを優先（CocoaPodsと併用しない）。
- **ビルド構成**: Debug / Release で挙動分岐（ログレベル、広告ID、デバッグUI）。
- **エラー耐性**: 外部依存の失敗はリカバーし、UIを止めない（フェールソフト）。
- **ログ**: 重要イベント（画面遷移、回答、最終スコア、広告表示）を print（Debugのみ詳細）。
- **レポート言語**: 以後の作業報告は日本語。

### 2.1 Xcode プロジェクト管理（厳守）

- `.xcodeproj` / `project.pbxproj` は手動編集禁止。
- 追加/削除は Xcode UI または XcodeGen/Tuist 等の宣言的生成で行う。
- 破損・競合時は再生成で解消。

### 2.2 Git 運用（重要）

- 既定で GitHub へ push しない（ローカルcommitまで）。
- こちらからの指示があった時のみ push / PR / merge / tag / release。
- main 直push禁止（明示許可時のみ）。force-push 禁止。
- 誤push防止：push直前に git remote -v と直近コミットログを表示。

## 3. データ設計（診断スキーマ）

**目的**：診断ロジックをJSONだけ差し替えで量産できるようにする。

### 3.1 データ配置

- **物理パス固定**：`Resources/assessments/`（青フォルダ＝Folder ReferenceでXcodeに追加）
- **ファイル名例**：
  - `diag_<namespace>_v1.json` … 質問と重み
  - `diag_<namespace>_results.json` … 結果カード（タイプ定義）

### 3.2 JSON スキーマ（質問・配点）

```json
{
  "version": "1.0",
  "meta": {
    "title": "表示名",
    "traits": ["I","A","P","L","J","S","C"],
    "tiebreak": ["I","S","C","P","A","L","J"]
  },
  "questions": [
    {
      "id": "q1",
      "text": "質問文",
      "choices": [
        {"key":"A","text":"選択肢A","weights":{"I":2,"C":1}},
        {"key":"B","text":"選択肢B","weights":{"S":2,"P":1}},
        {"key":"C","text":"選択肢C","weights":{"C":2,"A":1}},
        {"key":"D","text":"選択肢D","weights":{"P":2,"S":1}}
      ]
    }
  ],
  "scoring": {
    "mode": "linear_sum"
  }
}
```

### 3.3 JSON スキーマ（結果・マッピング）

```json
{
  "version": "1.0",
  "meta": { "title": "結果定義" },
  "profiles": [
    {
      "id": "nobunaga",
      "name": "織田信長",
      "formula": "3*I + 2*A + 2*C + 1*S",
      "summary": "120〜160字の結果文",
      "tips": ["今日の一手：…", "相性：…"]
    }
  ]
}
```

- `formula` は `n*Trait` の加算式（空白OK、`+` のみ）。
- 同点時は `tiebreak` 配列の順で決定。

## 4. 診断エンジン設計（実装要件）

- **加点モデル**: 回答の `weights` を都度合算 → `traits` ベクトルを構築。
- **スコアリング**: 各 `profile.formula` をパースし、`traits` 値を代入して合計点を算出。
- **タイブレーク**: 合計点同点の場合、`meta.tiebreak` の順で高い特性を持つプロフィールを採用。
- **再現性**: 同一回答セットは常に同一結果（乱数を使わない）。
- **フェールセーフ**: 必須キー欠落・空配列時はフォールバック結果を返す（後述）。

## 5. リソース読み込み（Repository 契約）

### 探索順：
1. `Bundle.main.resourceURL/assessments`
2. `Bundle.main.resourceURL/Resources/assessments`

- **必須**：質問JSON と 結果JSON の両方が揃っていること。
- **最小件数**：環境変数 `DIAG_MIN_QUESTIONS`（既定=3）。

### ログ：
```
[Repo] q=... count=... src=... min=... fallback=...
[Repo] r=... profiles=...
```

- **フォールバック**：最小件数未満・JSON不正時は内蔵データ（サンプル1セット）に切替。

## 6. Run Script 検証（スマートクオート/JSON不正をFail）

**Build Phases → Run Script（先頭）**に追加。Input/Outputを設定すること。

### Input Files
```
$(SRCROOT)/Resources/assessments
$(TARGET_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)
$(TARGET_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/assessments
$(TARGET_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/Resources/assessments
```

### Output Files
```
$(DERIVED_FILE_DIR)/validate_assessments.stamp
```

### 環境変数
- `DIAG_MIN_QUESTIONS` (既定=3)

### Run Script 本体

```bash
# Validate Assessment Resources
set -euo pipefail
APP_RES="${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
DIAG_MIN_QUESTIONS="${DIAG_MIN_QUESTIONS:-3}"
CANDIDATES=(
  "${APP_RES}/assessments"
  "${APP_RES}/Resources/assessments"
)
ADIR=""
for d in "${CANDIDATES[@]}"; do [ -d "$d" ] && { ADIR="$d"; break; }; done
[ -n "$ADIR" ] || { echo "[AS][ERR] assessments not found in app bundle"; exit 3; }

shopt -s nullglob
QFILES=( "${ADIR}"/diag_*_v*.json )
RFILES=( "${ADIR}"/diag_*_results.json )
[ ${#QFILES[@]} -ge 1 ] || { echo "[AS][ERR] 質問ファイルがありません"; exit 4; }
[ ${#RFILES[@]} -ge 1 ] || { echo "[AS][ERR] 結果ファイルがありません"; exit 5; }

# スマートクオート検出
if grep -rI -n $'\xE2\x80\x9C\|\xE2\x80\x9D\|\xE2\x80\x98\|\xE2\x80\x99' "${ADIR}" >/dev/null; then
  echo "[AS][ERR] smart quotes detected"; exit 6; fi

# JSON検証
for f in "${QFILES[@]}"; do
  echo "[AS] Validate questions: $f"
  /usr/bin/python3 - <<'PY' "$f" "$DIAG_MIN_QUESTIONS" || { echo "[AS][ERR] invalid questions JSON: $f"; exit 7; }
import json,sys
minc=int(sys.argv[2])
with open(sys.argv[1],'rb') as fp:
    data=json.load(fp)
assert isinstance(data, dict) and "questions" in data, "questions配列がありません"
qs=data["questions"]
assert isinstance(qs, list) and len(qs) >= minc, f"質問数 {len(qs)} < 最低 {minc}"
for q in qs:
    assert "choices" in q and len(q["choices"])>=2, "choices不足"
    for c in q["choices"]:
        assert "weights" in c and isinstance(c["weights"], dict), "weights欠落"
print("[AS] OK questions count=", len(qs))
PY
done

for f in "${RFILES[@]}"; do
  echo "[AS] Validate results: $f"
  /usr/bin/python3 - <<'PY' "$f" || { echo "[AS][ERR] invalid results JSON: $f"; exit 8; }
import json,sys,re
with open(sys.argv[1],'rb') as fp:
    data=json.load(fp)
assert isinstance(data, dict) and "profiles" in data, "profilesがありません"
profiles=data["profiles"]; assert isinstance(profiles, list) and len(profiles)>=1
for p in profiles:
    assert "id" in p and "name" in p and "formula" in p, "必須キー不足"
    assert re.match(r'^[0-9*+ IAPLJSC]+$', p["formula"].replace(' ','')), "formulaに無効文字"
print("[AS] OK profiles=", len(profiles))
PY
done

echo ok > "${DERIVED_FILE_DIR}/validate_assessments.stamp"
echo "[AS] All assessment resources OK."
```

## 7. UI フロー（最小構成）

- **Home**：タイトル／開始ボタン／規約リンク
- **QuestionView**：1問ずつ表示（プログレス、選択で自動次へ）
- **ResultCalc**：内部でスコア合算→プロフィール評価→タイブレーク
- **ResultView**：
  - 見出し「あなたに近いのは {name}」
  - サマリー（120–160字）
  - 強みTOP3（traitsの上位）
  - 今日の一手（tips[0]）
  - シェア画像生成（任意）
  - 再挑戦/共有ボタン
- **デバッグUI（Debug限定）**：右上に items:N / traits:{...} をトグル表示。

## 8. 設定・環境変数

- `DIAG_MIN_QUESTIONS`：最小質問数（既定=3）
- `ADS_ENABLED`：true/false（既定=false）
- `AD_UNIT_INTERSTITIAL_DEBUG` / `RELEASE`：広告ID
- `PRIVACY_URL` / `SUPPORT_URL`：ストア審査用リンク

## 9. 広告（任意）

- `AdsManager.swift` を用意し、Debug=テストID / Release=本番ID で切替。
- 画面遷移の節目（結果表示前など）に頻度制御付きで `preload()/show(from:)`。

## 10. アクセシビリティ/法的表記

- エンタメ用途である注記を `ResultView` 下部に常時表示。
- 診断結果を断定・差別に用いない旨のガイドを記載。
- Dynamic Type、VoiceOver、コントラスト配慮。

## 11. 受け入れ基準

- JSON差し替えでクラッシュなし・反映OK。
- Run Script がスマートクオートやJSON不正を確実にFail。
- 質問が `DIAG_MIN_QUESTIONS` 未満でもフォールバックで結果表示。
- 同一回答で常に同一結果が得られる。
- Debug ビルドで診断ログが確認できる。

## 12. Claude Code への依頼テンプレ（貼り付け可）

```
あなたは macOS 上で作業する開発オートメータです。GUI 操作は行わず、CLI とファイル編集のみで進めます。
既存フォルダ ~/Desktop/Claudecode/XXXX に 新規フォルダを作らず Xcode プロジェクトを作成。

SwiftUI / iOS 15+ / SPM

Resources/assessments を Folder Reference で追加

本 CLAUDE.md の Run Script を Build Phases 先頭に追加（Input/Output必須）

DIAG_MIN_QUESTIONS=3 を Debug/Release で設定

AdsManager.swift は雛形のみ（ADS_ENABLED=false 既定）

リポジトリに diag_sengoku_v1.json と diag_sengoku_results.json を配置し、ビルド・動作確認

実装後、変更差分（ファイル一覧/要約）とビルドログを日本語で報告
```
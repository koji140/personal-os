# AI Handoff Template

各プロジェクトの README に貼り付けるテンプレート。
`[...]` の部分をプロジェクト固有の内容に置き換える。

---

## テンプレート（コピー用）

```markdown
## AIへの引き継ぎ

新しいAIセッションを開始するときは、以下を読ませてください。

### 共通原則（personal-os）
- https://raw.githubusercontent.com/koji140/personal-os/main/operating-system.md
- https://raw.githubusercontent.com/koji140/personal-os/main/decision-principles.md

### このプロジェクト固有
- [このリポジトリのskill.md または docs/skill-xxx.md の raw URL]
- [未解決課題・現在の状態を記載したファイルの raw URL（あれば）]
```

---

## AIに渡す順序

1. `operating-system.md`（思考様式・問題の捉え方）
2. `decision-principles.md`（判断原則）
3. プロジェクト固有の skill または仕様書
4. 未解決課題・バグ記録（あれば）

この順序で渡すことで、原則を先に理解させてからプロジェクト文脈に入れる。

---

## 指示のポイント

AIに渡すとき、以下を添えると精度が上がる：

- **影響範囲**: 今回変更してよい範囲
- **必須変更点**: 必ず反映すべきこと
- **禁止事項**: 触れてはいけないこと
- **正本の場所**: 何を基準に判断するか

---

## ツール別の使い方

### GitHub Copilot（VS Code）
セッション開始時にチャットで raw URL を貼り付けて「読んでください」と伝える。
または `.github/copilot-instructions.md` に参照先を記載する。

### Claude（claude.ai / API）
会話の冒頭にURLを列挙して「これらを読んでから作業してください」と伝える。
長いドキュメントはそのままコンテキストに貼っても有効。

### ChatGPT（カスタムGPT）
カスタムGPTの Instructions に以下を記載する：
```
Before starting any task, read:
- https://raw.githubusercontent.com/koji140/personal-os/main/operating-system.md
- https://raw.githubusercontent.com/koji140/personal-os/main/decision-principles.md
```

### Cursor
`.cursor/rules/` または `CURSOR_RULES.md` に参照先を記載する。
エージェントモードでは会話冒頭に URL を渡す。

---

## 実装例（receipt-agent）

```markdown
## AIへの引き継ぎ

新しいAIセッションを開始するときは、以下を読ませてください。

### 共通原則（personal-os）
- https://raw.githubusercontent.com/koji140/personal-os/main/operating-system.md
- https://raw.githubusercontent.com/koji140/personal-os/main/decision-principles.md

### このプロジェクト固有
- スキル定義・未解決課題：https://raw.githubusercontent.com/koji140/receipt-agent/main/docs/skill-receipt-agent-dev.md
- バグ取り記録：https://raw.githubusercontent.com/koji140/receipt-agent/main/docs/receipt-agent-lessons.md
```

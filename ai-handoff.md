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

## 指示のポイント

AIに渡すとき、以下を添えると精度が上がる：

- **影響範囲**: 今回変更してよい範囲
- **必須変更点**: 必ず反映すべきこと
- **禁止事項**: 触れてはいけないこと
- **正本の場所**: 何を基準に判断するか

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

# personal-os

Koji Ishimaru の共通思想・判断原則・AIとの協業方針を集約した正本リポジトリ。

個別プロジェクトにコピーせず、各リポジトリの README からこのリポジトリの raw URL を参照する。

---

## このリポジトリの目的

- 思考パターン・判断原則を1箇所で管理する
- AIセッション開始時に読ませることで、プロジェクトをまたいで一貫した判断が得られる
- 複数リポジトリへのコピー・同期コストをゼロにする

---

## ファイル構成

| ファイル | 内容 |
|---|---|
| [core-skill.md](core-skill.md) | 中核スキルの定義（何者か・何が得意か） |
| [operating-system.md](operating-system.md) | 思考様式・問題の捉え方・AIとの分担方針 |
| [decision-principles.md](decision-principles.md) | 判断原則集（10原則） |
| [ai-handoff.md](ai-handoff.md) | 各プロジェクト README の「AIへの引き継ぎ」テンプレート |
| [docs/vps-github-layout.md](docs/vps-github-layout.md) | VPS 上の GitHub レポ配置ルール |

---

## 各プロジェクトからの参照方法

各プロジェクトの README に以下を追記する：

```markdown
## AIへの引き継ぎ

新しいAIセッションを開始するときは、以下を読ませてください。

### 共通原則（personal-os）
- https://raw.githubusercontent.com/koji140/personal-os/main/operating-system.md
- https://raw.githubusercontent.com/koji140/personal-os/main/decision-principles.md

### このプロジェクト固有
- [このrepoのskill.md または docs/skill-xxx.md のraw URL]
```

---

## 更新タイミング

- 新しい判断原則に気づいたとき
- 思考パターンが変化したとき
- 複数プロジェクトで同じ判断を繰り返していることに気づいたとき

**更新はこのリポジトリのみ。各プロジェクトへの反映は不要（参照のため自動的に最新版が使われる）。**

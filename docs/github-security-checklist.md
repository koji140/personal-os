# GitHub セキュリティチェックリスト

> スクリプト: `personal-os/scripts/github-security-check.ps1`  
> 最終確認: <!-- YYYY-MM-DD -->

---

## 実行方法

```powershell
# 実行ポリシーが制限されている場合
powershell -ExecutionPolicy Bypass -File .\scripts\github-security-check.ps1
```

---

## チェック項目

### A. 自動確認 (スクリプトで取得可)

| # | 項目 | gh コマンド | チェック |
|---|------|-------------|----------|
| 1 | gh CLI バージョン | `gh --version` | ☐ |
| 2 | 認証アカウント・スコープ | `gh auth status` | ☐ |
| 3 | ログイン済みアカウント一覧 | `gh auth list` | ☐ |
| 4 | GitHub 登録 SSH 鍵 | `gh ssh-key list` | ☐ |
| 5 | SSH 接続テスト | `ssh -T git@github.com` | ☐ |
| 6 | GitHub 登録 GPG 鍵 | `gh gpg-key list` | ☐ |
| 7 | 所属 Organization | `gh api /user/orgs` | ☐ |
| 8 | 自分のリポジトリ一覧 | `gh repo list --limit 50` | ☐ |
| 9 | 未承認コラボレーター招待 | `gh api /user/repository_invitations` | ☐ |
| 10 | インストール済み GitHub Apps | `gh api /user/installations` | ☐ |

### B. 手動確認 (Web UI 必須)

| # | 項目 | URL | チェック |
|---|------|-----|----------|
| 11 | Personal Access Tokens (Classic) | https://github.com/settings/tokens | ☐ |
| 12 | Fine-grained PAT | https://github.com/settings/tokens?type=beta | ☐ |
| 13 | OAuth アプリ認可 | https://github.com/settings/applications | ☐ |
| 14 | GitHub Apps | https://github.com/settings/installations | ☐ |
| 15 | アクティブなセッション | https://github.com/settings/sessions | ☐ |
| 16 | SSH 鍵 (Web 確認) | https://github.com/settings/keys | ☐ |
| 17 | GPG 鍵 (Web 確認) | https://github.com/settings/gpg-keys | ☐ |
| 18 | メール設定・プライバシー | https://github.com/settings/emails | ☐ |
| 19 | 2FA 有効確認 | https://github.com/settings/security | ☐ |

---

## 判断基準：不要な接続の洗い出し

### SSH 鍵
- [ ] 使用中のマシン分のみ残っているか
- [ ] タイトルにマシン名 / 用途が明記されているか
- [ ] 90日以上使われていない鍵は削除を検討

### PAT (Personal Access Token)
- [ ] 有効期限が設定されているか（無期限は原則禁止）
- [ ] スコープが最小権限になっているか（`repo` 全体よりも Fine-grained を優先）
- [ ] 使い終わったアプリ・スクリプト分の PAT は残っていないか

### OAuth / GitHub Apps
- [ ] 現在も使っているサービスのみか
- [ ] `write` / `admin` 権限を持つアプリは特に要確認
- [ ] CI/CD ツール系は Org 設定側で管理されているか

### Organization
- [ ] 意図せず招待承認した Org がないか
- [ ] 退職・プロジェクト終了後のロールが残っていないか

---

## 対応フロー

```
疑わしい接続を発見
    │
    ├─ 使用記憶なし → 即削除
    ├─ 過去利用・現在不要 → 削除
    ├─ 必要だが権限過剰 → Fine-grained PAT に切替
    └─ 現在も必要 → タイトル・スコープを整理してメモ
```

---

## 定期実行推奨サイクル

| 頻度 | 項目 |
|------|------|
| 月次 | スクリプト全実行、PAT 期限確認 |
| 四半期 | OAuth/GitHub Apps 棚卸し、SSH 鍵の利用状況確認 |
| 随時 | 作業終了時に一時 PAT を削除 |

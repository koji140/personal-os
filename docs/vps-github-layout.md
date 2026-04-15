# VPS GitHub レポ配置ルール

VPS 上の GitHub レポの作業コピー配置と運用ルールを定義する。

---

## 正本

VPS 上の GitHub レポは、原則としてすべて以下に配置する。

```text
/root/github/<repo-name>
```

例:

- `/root/github/vps`
- `/root/github/personal-os`
- `/root/github/eventhub`

---

## この構成にしている理由

- 単独運用のため、root 管理で十分
- 全レポの配置先を1箇所に固定できる
- clone / pull / 差分確認の場所が毎回ぶれない
- VPS 内の GitHub 関連資産を機械的に探索しやすい

---

## 運用ルール

### 1. clone 先を固定する

新しいレポを取得するときは、必ず `/root/github` 配下に clone する。

```bash
cd /root/github
gh repo clone koji140/<repo-name> /root/github/<repo-name>
```

### 2. 既存レポも同じ場所に揃える

例外的に別の場所へ clone しない。
VPS 上の GitHub 作業コピーは `/root/github` に集約する。

### 3. サーバー設定と個人運用ルールは分ける

- `vps` レポ: VPS セットアップ、デプロイ、systemd、nginx、スクリプト
- `personal-os` レポ: 個人の運用原則、配置ルール、作業方針

### 4. `/root/github` 直下には Git 管理されていないメモを置かない

横断ルールを残す場合は、`personal-os` に記録する。
`/root/github` 直下は親ディレクトリであり、そこに置いた単体ファイルは Git 履歴に残らない。

---

## 確認コマンド

### 配置確認

```bash
find /root/github -maxdepth 1 -mindepth 1 -type d | sort
```

### Git レポ確認

```bash
find /root/github -maxdepth 2 -name .git -type d
```

### GitHub から未取得レポを確認する前提コマンド

```bash
gh repo list koji140 --limit 100
```

---

## 例外

将来、複数ユーザー運用や非 root 実行へ移行する場合は、このルールを見直す。
その場合の候補は以下。

- `/home/<user>/github`
- `/srv/github`

現時点では、単独運用のため `/root/github` を正本とする。

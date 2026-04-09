# github-security-check.ps1
# GitHub セキュリティ状態チェックスクリプト (gh CLI + ssh)
# 実行前提: gh auth login 済み、ssh-agent 起動済み

# PowerShell が外部コマンドの出力を受け取る際のエンコーディングを UTF-8 に統一
[System.Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[System.Console]::InputEncoding  = [System.Text.Encoding]::UTF8
$OutputEncoding                   = [System.Text.Encoding]::UTF8

$Separator = "=" * 60

function Section($title) {
    Write-Host "`n$Separator" -ForegroundColor Cyan
    Write-Host "  $title" -ForegroundColor Cyan
    Write-Host $Separator -ForegroundColor Cyan
}

function Ok($msg)   { Write-Host "[OK]  $msg" -ForegroundColor Green }
function Warn($msg) { Write-Host "[!!]  $msg" -ForegroundColor Yellow }
function Info($msg) { Write-Host "      $msg" -ForegroundColor Gray }

# ─────────────────────────────────────────────
# 1. gh CLI インストール確認
# ─────────────────────────────────────────────
Section "1. gh CLI インストール確認"
if (Get-Command gh -ErrorAction SilentlyContinue) {
    $ghVersion = gh --version | Select-Object -First 1
    Ok "gh CLI: $ghVersion"
} else {
    Warn "gh CLI が見つかりません。https://cli.github.com/ からインストールしてください。"
    exit 1
}

# ─────────────────────────────────────────────
# 2. 認証状態
# ─────────────────────────────────────────────
Section "2. 認証状態 (gh auth status)"
gh auth status
Write-Host ""

# ログイン中アカウント確認 (gh auth switch で複数アカウント切替可)
$currentUser = gh api /user --jq '.login' 2>&1
Info "現在のログインユーザー: $currentUser"

# ─────────────────────────────────────────────
# 3. SSH 鍵一覧 (GitHub に登録済み)
# ─────────────────────────────────────────────
Section "3. GitHub に登録された SSH 鍵"
$sshRaw = gh api user/keys 2>&1
if ($LASTEXITCODE -eq 0) {
    $sshList = $sshRaw -join "" | ConvertFrom-Json
    if ($sshList.Count -eq 0) {
        Ok "登録済み SSH 鍵なし"
    } else {
        Ok "SSH 鍵 $($sshList.Count) 件"
        $sshList | ForEach-Object {
            Info "  title      : $($_.title)"
            Info "  created_at : $($_.created_at)"
            Info "  verified   : $($_.verified)"
            Info "  read_only  : $($_.read_only)"
            Info "  --------"
        }
        Warn "不要な鍵がないか確認: https://github.com/settings/keys"
    }
} else {
    $errMsg = $sshRaw -join " "
    if ($errMsg -match 'scope|permission|403|401|insufficient') {
        Warn "スコープ / 権限不足 (エラー詳細↓)"
        Info "  $errMsg"
        Info "  必要なら: gh auth refresh -h github.com -s admin:public_key"
    } else {
        Warn "SSH 鍵取得エラー:"
        Info "  $errMsg"
    }
    Info "  Web 確認: https://github.com/settings/keys"
}

# ─────────────────────────────────────────────
# 4. SSH 接続テスト
# ─────────────────────────────────────────────
Section "4. SSH 接続テスト (git@github.com)"
$knownHostsPath = "$env:USERPROFILE\.ssh\known_hosts"
$githubKnown = (Test-Path $knownHostsPath) -and
               ((Get-Content $knownHostsPath -ErrorAction SilentlyContinue) -match "github\.com")

if ($githubKnown) {
    $sshResult = ssh -T -o BatchMode=yes -o StrictHostKeyChecking=yes git@github.com 2>&1
    $sshStr = $sshResult -join " "
    if ($sshStr -match "successfully authenticated") {
        Ok $sshStr
    } else {
        Warn "SSH 認証失敗またはキー不一致:"
        Info "  $sshStr"
        Info "  GitHub に正しい SSH 鍵が登録されているか確認してください"
    }
} else {
    Warn "github.com が known_hosts に未登録です (SSH テストをスキップ)"
    Info "初回登録コマンド:"
    Info "  ssh-keyscan -H github.com >> ~/.ssh/known_hosts"
    Info "  その後このスクリプトを再実行してください"
}

# ─────────────────────────────────────────────
# 5. GPG 鍵一覧 (GitHub に登録済み)
# ─────────────────────────────────────────────
Section "5. GitHub に登録された GPG 鍵"
$gpgRaw = gh api user/gpg_keys 2>&1
if ($LASTEXITCODE -eq 0) {
    $gpgList = $gpgRaw -join "" | ConvertFrom-Json
    if ($gpgList.Count -eq 0) {
        Ok "登録済み GPG 鍵なし"
    } else {
        Ok "GPG 鍵 $($gpgList.Count) 件"
        $gpgList | ForEach-Object {
            Info "  name       : $($_.name)"
            Info "  key_id     : $($_.key_id)"
            Info "  created_at : $($_.created_at)"
            Info "  expires_at : $($_.expires_at)"
            Info "  --------"
        }
        Warn "不要な鍵がないか確認: https://github.com/settings/gpg-keys"
    }
} else {
    $errMsg = $gpgRaw -join " "
    if ($errMsg -match 'scope|permission|403|401|insufficient') {
        Warn "スコープ / 権限不足 (エラー詳細↓)"
        Info "  $errMsg"
        Info "  必要なら: gh auth refresh -h github.com -s read:gpg_key"
    } else {
        Warn "GPG 鍵取得エラー:"
        Info "  $errMsg"
    }
    Info "  Web 確認: https://github.com/settings/gpg-keys"
}

# ─────────────────────────────────────────────
# 6. 所属 Organization 一覧
# ─────────────────────────────────────────────
Section "6. 所属 Organization 一覧"
$orgs = gh api /user/orgs --jq '.[].login' 2>&1
if ($orgs) {
    $orgs | ForEach-Object { Info "  Org: $_" }
} else {
    Info "(所属 Org なし)"
}

# ─────────────────────────────────────────────
# 7. リポジトリ一覧 (自分のもの)
# ─────────────────────────────────────────────
Section "7. 自分のリポジトリ一覧 (最大 50件)"
$reposRaw = gh api '/user/repos?per_page=50&sort=pushed' 2>&1
if ($LASTEXITCODE -eq 0) {
    $repos = $reposRaw -join "" | ConvertFrom-Json
    $repos | ForEach-Object {
        $vis = if ($_.private) { 'private' } else { 'public ' }
        $pushedDate = $_.pushed_at -replace 'T.*', ''
        Info "  [$vis] $($_.name.PadRight(40)) pushed: $pushedDate"
    }
} else {
    Warn "リポジトリ取得エラー: $reposRaw"
}

# ─────────────────────────────────────────────
# 8. コラボレーター招待 (受信済み)
# ─────────────────────────────────────────────
Section "8. 保留中のコラボレーター招待"
$invitations = gh api /user/repository_invitations --jq '.[].repository.full_name' 2>&1
if ($invitations) {
    Warn "未承認の招待:"
    $invitations | ForEach-Object { Warn "  -> $_" }
} else {
    Ok "保留中の招待なし"
}

# ─────────────────────────────────────────────
# 9. インストール済み GitHub Apps (要確認)
# ─────────────────────────────────────────────
Section "9. インストール済み GitHub Apps"
# /user/installations は GitHub App トークンが必要なため CLI での取得不可
Warn "GitHub Apps の一覧は Web での確認が必須:"
Info "  https://github.com/settings/installations"

# ─────────────────────────────────────────────
# 10. Personal Access Tokens (Web UI のみ)
# ─────────────────────────────────────────────
Section "10. Personal Access Tokens (PAT) ← Web 確認必須"
Warn "gh CLI で一覧取得不可。以下 URL で確認:"
Info "  Classic PAT : https://github.com/settings/tokens"
Info "  Fine-grained: https://github.com/settings/tokens?type=beta"

# ─────────────────────────────────────────────
# 11. OAuth アプリ認可 (Web UI のみ)
# ─────────────────────────────────────────────
Section "11. OAuth アプリ認可 ← Web 確認必須"
Warn "gh CLI で一覧取得不可。以下 URL で確認:"
Info "  https://github.com/settings/applications"

# ─────────────────────────────────────────────
# 完了サマリ
# ─────────────────────────────────────────────
Section "チェック完了"
Write-Host @"
手動確認リンク (ブラウザで開いて不要なものを削除):
  SSH 鍵      : https://github.com/settings/keys
  GPG 鍵      : https://github.com/settings/gpg-keys
  PAT (Classic): https://github.com/settings/tokens
  PAT (FGA)   : https://github.com/settings/tokens?type=beta
  OAuth Apps  : https://github.com/settings/applications
  GitHub Apps : https://github.com/settings/installations
  Sessions    : https://github.com/settings/sessions
"@ -ForegroundColor White

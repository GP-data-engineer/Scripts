# === Konfiguracja ===
$GitHubUser = "GP-data-engineer"   # nazwa użytkownika na GitHub
$TargetDir  = "C:\GitHub\Repo"     # katalog docelowy

# Utwórz katalog, jeśli nie istnieje
if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir | Out-Null
}

# Pobierz listę publicznych repozytoriów z GitHub API
$repos = Invoke-RestMethod -Uri "https://api.github.com/users/$GitHubUser/repos?per_page=100" `
    -Headers @{ "User-Agent" = "PowerShell" }

# Przejdź do katalogu docelowego
Set-Location $TargetDir

# Sklonuj każde repozytorium
foreach ($repo in $repos) {
    $name = $repo.name
    $cloneUrl = $repo.clone_url
    Write-Host "Klonuję repozytorium: $name ..." -ForegroundColor Cyan
    git clone $cloneUrl
}

Write-Host "✅ Wszystkie repozytoria zostały pobrane do $TargetDir" -ForegroundColor Green

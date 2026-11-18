param(
    [switch]$Pull,
    [switch]$Push,
    [string]$TargetSkillsDir = "$HOME\.gemini\config\skills",
    [string]$TargetRulesFile = "$HOME\.gemini\GEMINI.md"
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
$RepoSkills = Join-Path $RepoRoot "skills"
$RepoRules = Join-Path $RepoRoot "rules\GEMINI.md"

if (-not $Pull -and -not $Push) {
    $Pull = $true
}

if ($Pull) {
    Write-Host "==> Pulling latest workflows & skills from origin/main..." -ForegroundColor Cyan
    Push-Location $RepoRoot
    try {
        git pull --ff-only origin main
    } finally {
        Pop-Location
    }

    New-Item -ItemType Directory -Force -Path $TargetSkillsDir | Out-Null
    Copy-Item -Path "$RepoSkills\*" -Destination $TargetSkillsDir -Recurse -Force
    Write-Host "==> Synced skills to: $TargetSkillsDir" -ForegroundColor Green

    if ($TargetRulesFile) {
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $TargetRulesFile) | Out-Null
        Copy-Item -Path $RepoRules -Destination $TargetRulesFile -Force
        Write-Host "==> Synced global rules to: $TargetRulesFile" -ForegroundColor Green
    }
}

if ($Push) {
    Write-Host "==> Copying local skills & global rules into repo checkout ($RepoRoot)..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Force -Path $RepoSkills | Out-Null
    Copy-Item -Path "$TargetSkillsDir\*" -Destination $RepoSkills -Recurse -Force

    if (Test-Path $TargetRulesFile) {
        Copy-Item -Path $TargetRulesFile -Destination $RepoRules -Force
    }

    Push-Location $RepoRoot
    try {
        git status -s
        Write-Host "==> Local changes copied into $RepoRoot. Review 'git status' above, then commit and push." -ForegroundColor Green
    } finally {
        Pop-Location
    }
}

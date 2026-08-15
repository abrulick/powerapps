param(
    [Parameter(Mandatory = $true)]
    [string]$TargetRoot
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command pac -ErrorAction SilentlyContinue)) {
    throw "Power Platform CLI (pac) is not available in PATH. Install/update it before running this script."
}

$packageRoot = Split-Path $PSScriptRoot -Parent
$overlayRoot = Join-Path $packageRoot "PCF\PresenceOrgChart"

if (Test-Path $TargetRoot) {
    if ((Get-ChildItem -Force $TargetRoot | Measure-Object).Count -gt 0) {
        throw "TargetRoot already exists and is not empty: $TargetRoot"
    }
} else {
    New-Item -ItemType Directory -Path $TargetRoot | Out-Null
}

Push-Location $TargetRoot
try {
    pac pcf init --namespace OrgPresence --name PresenceOrgChart --template dataset --run-npm-install

    $controlFolder = Join-Path $TargetRoot "PresenceOrgChart"
    Copy-Item (Join-Path $overlayRoot "ControlManifest.Input.xml") (Join-Path $controlFolder "ControlManifest.Input.xml") -Force
    Copy-Item (Join-Path $overlayRoot "index.ts") (Join-Path $controlFolder "index.ts") -Force

    $cssFolder = Join-Path $controlFolder "css"
    if (-not (Test-Path $cssFolder)) {
        New-Item -ItemType Directory -Path $cssFolder | Out-Null
    }
    Copy-Item (Join-Path $overlayRoot "css\PresenceOrgChart.css") (Join-Path $cssFolder "PresenceOrgChart.css") -Force

    Write-Host "PCF scaffold created and source overlay applied." -ForegroundColor Green
    Write-Host "Next: cd '$TargetRoot' and run npm run build"
}
finally {
    Pop-Location
}

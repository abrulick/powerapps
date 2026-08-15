param(
    [Parameter(Mandatory = $true)]
    [string]$PcfProjectRoot,

    [Parameter(Mandatory = $true)]
    [string]$SolutionRoot,

    [string]$PublisherName = "OrgPresencePublisher",
    [string]$PublisherPrefix = "orgp"
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command pac -ErrorAction SilentlyContinue)) {
    throw "Power Platform CLI (pac) is not available in PATH."
}

if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) {
    throw ".NET SDK is not available in PATH. Install .NET SDK 6 or newer, or build with MSBuild manually."
}

if (-not (Test-Path $PcfProjectRoot)) {
    throw "PCF project path not found: $PcfProjectRoot"
}

if (Test-Path $SolutionRoot) {
    if ((Get-ChildItem -Force $SolutionRoot | Measure-Object).Count -gt 0) {
        throw "SolutionRoot already exists and is not empty: $SolutionRoot"
    }
} else {
    New-Item -ItemType Directory -Path $SolutionRoot | Out-Null
}

Push-Location $SolutionRoot
try {
    pac solution init --publisher-name $PublisherName --publisher-prefix $PublisherPrefix
    pac solution add-reference --path $PcfProjectRoot
    dotnet build -c Release

    Write-Host "Solution Release build completed." -ForegroundColor Green
    Write-Host "Inspect the bin\Release output folder for the generated solution package."
}
finally {
    Pop-Location
}

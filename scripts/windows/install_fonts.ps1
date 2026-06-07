# install_fonts.ps1 — Install all TTF fonts from the dotfiles Fonts directory
# Run as Administrator
#
# Usage:
#    .\install_fonts.ps1         -> Install all fonts
#    .\install_fonts.ps1 -DryRun -> Preview without installing

param(
    [switch]$DryRun
)

# -------------------------------------------------------
# Elevation check
# -------------------------------------------------------
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal   = New-Object Security.Principal.WindowsPrincipal($currentUser)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

# -------------------------------------------------------
# Locate Fonts directory (repo root, two levels up)
# -------------------------------------------------------
$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot "..\..\"))
$fontsRoot = Join-Path $repoRoot "Fonts"

if (-not (Test-Path $fontsRoot)) {
    Write-Error "Fonts directory not found at: $fontsRoot"
    exit 1
}

Write-Host "`n==> Installing fonts from: $fontsRoot`n"

# -------------------------------------------------------
# Install
# -------------------------------------------------------
$registryKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
$installed   = 0
$skipped     = 0

$fontFiles = Get-ChildItem $fontsRoot -Recurse -Filter *.ttf

foreach ($font in $fontFiles) {
    $name         = $font.BaseName
    $registryName = "$name (TrueType)"
 
    $alreadyInstalled = (Test-Path "$env:WINDIR\Fonts\$($font.Name)") -or
                        (Get-ItemProperty -Path $registryKey `
                                         -Name $registryName `
                                         -ErrorAction SilentlyContinue)

    if ($alreadyInstalled) {
        Write-Host "  Skipping: $name (already installed)"
        $skipped++
        continue
    }
 
    if ($DryRun) {
        Write-Host "  [DryRun] Would install: $name"
        $installed++
        continue
    }
 
    Copy-Item $font.FullName -Destination "$env:WINDIR\Fonts" -Force
    New-ItemProperty -Path $registryKey `
                     -Name $registryName `
                     -PropertyType String `
                     -Value $font.Name `
                     -Force | Out-Null
 
    Write-Host "  Installed: $name"
    $installed++
}
 
Write-Host "`nDone. Installed: $installed, Skipped: $skipped."

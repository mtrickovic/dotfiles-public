# setup.ps1 — Windows dotfiles setup
# Run as Administrator
#
# Usage:
#    .\setup.ps1                  -> Create symlinks from links.json
#    .\setup.ps1 -InstallPackages -> Install packages only
#    .\setup.ps1 -DryRun          -> Preview symlinks without creating them

param(
    [switch]$InstallPackages,
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
# Helpers
# -------------------------------------------------------

function Expand-HomePath {
    param([string]$Path)
    # Replace ~ with $HOME, then expand any remaining $env: variables
    $Path = $Path -replace '^~', $HOME
    return [System.Environment]::ExpandEnvironmentVariables($Path)
}

function Backup-IfExists {
    param([string]$Path)
    $backup = "$Path.bak"
    if (Test-Path $backup) {
        Write-Host "  Backup already exists: $backup"
    } elseif (Test-Path $Path) {
        Rename-Item -Path $Path -NewName "$Path.bak" -Force
        Write-Host "  Backed up: $Path -> $backup"
    }
}

function New-Symlink {
    param(
        [string]$Source,
        [string]$Target,
        [switch]$DryRun
    )

    if (-not (Test-Path $Source)) {
        Write-Warning "  Source not found, skipping: $Source"
        return
    }

    $isDir    = (Get-Item $Source).PSIsContainer
    $itemType = if ($isDir) { "Junction" } else { "SymbolicLink" }

    if ($DryRun) {
        Write-Host "  [DryRun] $Target -> $Source"
        return
    }

    # If target already exists and is a symlink/junction, skip entirely
    if (Test-Path $Target) {
        $item = Get-Item $Target -Force
        if ($item.LinkType -eq "SymbolicLink" -or $item.LinkType -eq "Junction") {
            Write-Host "  Already linked, skipping: $Target"
            return
        }
    }

    # Backup existing real file/dir at target location
    Backup-IfExists $Target

    # Ensure parent directory exists
    $parentDir = Split-Path $Target -Parent
    if (-not (Test-Path $parentDir)) {
        New-Item -Path $parentDir -ItemType Directory -Force | Out-Null
        Write-Host "  Created directory: $parentDir"
    }

    New-Item -ItemType $itemType -Path $Target -Target $Source -Force | Out-Null
    Write-Host "  Linked: $Target -> $Source"
}

# -------------------------------------------------------
# Mode: Install packages
# -------------------------------------------------------
function Install-Packages {
    Write-Host "`n==> Installing packages via winget...`n"

    $packages = @(
        'Microsoft.PowerShell',
        'JanDeDobbeleer.OhMyPosh',
        'Git.Git',
        'GitHub.cli',
        'SublimeHQ.SublimeText.4',
        'Neovim.Neovim',
        'Perforce.P4Merge',
        'Hibbiki.Chromium',
        'Mozilla.Firefox',
        'Microsoft.OpenSSH.Preview'
    )

    foreach ($pkg in $packages) {
        Write-Host "  Installing $pkg ..."
        winget install $pkg --silent `
                            --accept-package-agreements `
                            --accept-source-agreements
    }

    Write-Host "  Installing JetBrainsMono Nerd Font..."
    oh-my-posh font install JetBrainsMono

    Write-Host "`nPackage installation complete."
}

# -------------------------------------------------------
# Mode: Install symlinks
# -------------------------------------------------------
function Install-Symlinks {
    # links.json lives at repo root, two levels up from scripts/windows/
    $linksFile = Join-Path $PSScriptRoot "..\..\links.json"
    $linksFile = [System.IO.Path]::GetFullPath($linksFile)

    if (-not (Test-Path $linksFile)) {
        Write-Error "links.json not found at: $linksFile"
        exit 1
    }

    Write-Host "`n==> Reading links from: $linksFile`n"

    $json  = Get-Content $linksFile -Raw | ConvertFrom-Json
    $links = $json.links

    foreach ($entry in $links) {
        # Skip entries not meant for Windows
        if ($entry.platform -and $entry.platform -ne "windows") {
            continue
        }

        # Skip comment-only entries (no source/target)
        if (-not $entry.source -or -not $entry.target) {
            continue
        }

        $source = Expand-HomePath $entry.source
        $target = Expand-HomePath $entry.target

        $label = if ($entry.comment) { $entry.comment } else { $source }
        Write-Host "[$label]"
        New-Symlink -Source $source -Target $target -DryRun:$DryRun
    }

    Write-Host "`nSymlink setup complete."
}

# -------------------------------------------------------
# Entry point
# -------------------------------------------------------
if ($InstallPackages) {
    Install-Packages
} else {
    Install-Symlinks
}

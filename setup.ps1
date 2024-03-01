# setup.ps1

param(
    [switch]$InstallPackages
)

# Install required packages
if ($InstallPackages) {
    $packages = @(
        'Microsoft.PowerShell',
        'JanDeDobbeleer.OhMyPosh',
        'Git.Git',
        'GitHub.cli',
        'SublimeHQ.SublimeText.4',
        'Neovim.Neovim',
        'Perforce.P4Merge',
        'Google.Chrome'
    )

    foreach ($package in $packages) {
        Write-Host "Installing $package..."
        winget install $package
    }
}

# Function to create symbolic links
function Create-Symlink {
    param(
        [string]$target,
        [string]$link
    )

    cmd /c mklink /H $link $target
}

# Create powershell directory (if doesn't exists)
$powerShellDirectory = Join-Path $HOME\Documents -ChildPath 'PowerShell'

if (-not (Test-Path $powerShellDirectory -PathType Container)) {
    New-Item -Path $powerShellDirectory -ItemType Directory
    Write-Host "PowerShell directory created: $powerShellDirectory"
}

# Create backup for Sublime Text Settings
$sublLoc = Join-Path $env:APPDATA 'Sublime Text\Packages\User'
$sublLink = Join-Path $sublLoc 'Preferences.sublime-settings'
$sublBackup = Join-Path $sublLoc 'Preferences.sublime-settings.bak'

if (Test-Path $sublBackup -PathType Leaf) {
    Write-Host "Backup file for Sublime already exists: $sublBackup"
} elseif (Test-Path $sublLink -PathType Leaf) {
    Rename-Item -Path $sublLink -NewName 'Preferences.sublime-settings.bak' -Force
    Write-Host "Existing file backed up to: $sublBackup"
}

# Rename existing nvim directory in LOCALAPPDATA to nvim.bak
$nvimLink = Join-Path $env:LOCALAPPDATA 'nvim'
$nvimBackup = Join-Path $env:LOCALAPPDATA 'nvim.bak'

if (Test-Path $nvimBackup -PathType Container) {
    Write-Host "Backup directory already exists: $nvimBackup"
} elseif (Test-Path $nvimLink -PathType Container) {
    Rename-Item -Path $nvimLink -NewName 'nvim.bak' -Force
    Write-Host "Existing nvim directory renamed to nvim.bak"
}

# Set up symbolic links for configuration files

# Define variables for paths
$gitconfigPath = (Get-Item .\.gitconfig).FullName
$profilePath = (Get-Item .\profile.ps1).FullName
$vimrcPath = (Get-Item .\.vimrc).FullName
$preferencesPath = (Get-Item .\Preferences.sublime-settings).FullName
$nvimPath = (Get-Item .\nvim).FullName
$themePath = (Get-Item .\powerflow.omp.json).FullName

# Set up symbolic links for configuration files
Create-Symlink $gitconfigPath $env:USERPROFILE\.gitconfig
Create-Symlink $profilePath $env:USERPROFILE\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
Create-Symlink $profilePath $env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
Create-Symlink $vimrcPath $env:USERPROFILE\.vimrc
Create-Symlink $preferencesPath $env:APPDATA\'Sublime Text'\Packages\User\Preferences.sublime-settings
Create-Symlink $themePath $env:POSH_THEMES_PATH\powerflow.omp.json
cmd /c mklink /D $nvimLink $nvimPath

Write-Host "Dotfiles setup complete."

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

    cmd /c mklink $link $target
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

# Create backup for Windows Terminal Settings
$terminalSettingsLoc = $env:LOCALAPPDATA + 
                    '\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState'
$terminalSettingsLink = $terminalSettingsLoc + '\settings.json'
$terminalSettingsBackup = $terminalSettingsLoc + '\settings.json.bak'

if (Test-Path $terminalSettingsBackup -PathType Leaf) {
    Write-Host "Backup file already exists: $terminalSettingsBackup"
} elseif (Test-Path $terminalSettingsLink -PathType Leaf) {
    Rename-Item -Path $terminalSettingsLink -NewName 'settings.json.bak' -Force
    Write-Host "Existing settings.json file renamed to settings.json.bak"
}

# Set up symbolic links for configuration files

# Define variables for paths
$gitconfigPath = (Get-Item .\.gitconfig).FullName
$profilePath = (Get-Item .\profile.ps1).FullName
$vimrcPath = (Get-Item .\.vimrc).FullName
$preferencesPath = (Get-Item .\Preferences.sublime-settings).FullName
$nvimPath = (Get-Item .\nvim).FullName
$themePath = (Get-Item .\powerflow.omp.json).FullName
$terminalPath = (Get-Item .\settings.json).FullName

# Define variables for links
$gitconfigLink = $env:USERPROFILE + '\.gitconfig'
$profileDocPath = $env:USERPROFILE + '\Documents'
$pwshProfilePath = $profileDocPath + '\WindowsPowerShell\' +
                    'Microsoft.PowerShell_profile.ps1'
$pwshProfilePathAlt = $profileDocPath + '\PowerShell\' +
                    'Microsoft.PowerShell_profile.ps1'
$vimrcLink = $env:USERPROFILE + '\.vimrc'
$themeLink = $env:POSH_THEMES_PATH + '\powerflow.omp.json'

# Set up symbolic links for configuration files
Create-Symlink $gitconfigPath $gitconfigLink
Create-Symlink $profilePath $pwshProfilePath
Create-Symlink $profilePath $pwshProfilePathAlt
Create-Symlink $vimrcPath $vimrcLink
Create-Symlink $preferencesPath $sublLink
Create-Symlink $themePath $themeLink
Create-Symlink $terminalPath $terminalSettingsLink
cmd /c mklink /D $nvimLink $nvimPath

Write-Host "Dotfiles setup complete."

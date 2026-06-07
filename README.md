# Dotfiles Repository

![PowerShell][badge-ps]
![Git][badge-git]
![Windows Terminal][badge-wt]
![Neovim][badge-nvim]
![License][badge-license]

<!-- MarkdownTOC -->

- [Contents](#contents)
   - [Configuration Files](#configuration-files)
   - [Scripts](#scripts)
- [Quick Start](#quick-start)
   - [Windows Installation](#windows-installation)
   - [Linux Installation](#linux-installation)
- [Requirements](#requirements)
   - [Essential](#essential)
   - [Recommended](#recommended)
   - [Optional Tools](#optional-tools)
- [Configuration Details](#configuration-details)
   - [Git Configuration](#git-configuration)
   - [Line Endings](#line-endings)
   - [PowerShell Profile](#powershell-profile)
   - [Vim/Neovim Configuration](#vimneovim-configuration)
   - [Windows Terminal](#windows-terminal)
   - [Fonts](#fonts)
- [Repository Structure](#repository-structure)
- [Usage](#usage)
   - [Git Aliases](#git-aliases)
   - [PowerShell Aliases](#powershell-aliases)
   - [Customization](#customization)
- [Platform-Specific Notes](#platform-specific-notes)
   - [Windows](#windows)
   - [Linux](#linux)
- [Troubleshooting](#troubleshooting)
   - [PowerShell profile not loading](#powershell-profile-not-loading)
   - [Fonts not displaying](#fonts-not-displaying)
   - [SSH commit signing issues](#ssh-commit-signing-issues)
- [Migration from Old Config](#migration-from-old-config)
- [Updates and Maintenance](#updates-and-maintenance)
   - [Pulling Latest Changes](#pulling-latest-changes)
   - [Rerunning Setup \(Windows\)](#rerunning-setup-windows)
   - [Syncing Across Machines](#syncing-across-machines)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

<!-- /MarkdownTOC -->

A curated collection of configuration files and setup scripts for a productive, cross-platform development environment.

**Compatible with:** Windows 10/11, Linux (Arch, Ubuntu, Debian)

---

## Contents

### Configuration Files

- **PowerShell Profile** - Custom prompt, aliases, and productivity enhancements
- **Git Configuration** - Cross-platform setup with modern aliases and settings
- **Vim/Neovim** - Editor configuration with Solarized theme
- **Sublime Text** - Editor preferences and settings
- **Windows Terminal** - Custom color schemes and terminal configuration
- **oh-my-posh** - PowerShell prompt theme (powerflow)

### Scripts

- **setup.ps1** - Automated installation and configuration (Windows)
- **install_fonts.ps1** - Fonts installer (Windows)

---

## Quick Start

### Windows Installation

```powershell
# Clone the repository
git clone https://github.com/mtrickovic/dotfiles-public.git dotfiles
cd dotfiles

# Run as Administrator
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

.\scripts\windows\setup.ps1 -InstallPackages # Install packages + fonts
.\scripts\windows\setup.ps1 -DryRun          # Preview symlinks
.\scripts\windows\setup.ps1                  # Create symlinks
```

### Linux Installation

```bash
# Clone the repository
git clone https://github.com/mtrickovic/dotfiles-public.git dotfiles
cd dotfiles

# Use dotmap-cli to create symlinks from links.json
dotmap link
```

---

## Requirements

### Essential

- **Git** 2.13+ (for includeIf support)
- **PowerShell** 5.0+ (Windows) or PowerShell Core 7+ (cross-platform)

### Recommended

- **oh-my-posh** - For custom PowerShell prompt
- **Nerd Fonts** - For icon support in terminal (optional but recommended)
- **Windows Terminal** - Modern terminal for Windows
- **Neovim** 0.5+ - Enhanced Vim experience

### Optional Tools

- **Sublime Text 4** - Text editor
- **Terminal-Icons** - PowerShell module for file icons
- **PSReadLine** - Enhanced command-line editing

---

## Configuration Details

### Git Configuration

Split into multiple files for cross-platform compatibility:

- **`.gitconfig`** - Main configuration (works on all platforms)
- **`.gitconfig-linux`** - Linux-specific overrides (editor, diff tool)
- **`.gitconfig-windows`** - Windows-specific overrides

Features:
- 30+ useful aliases (lg, hist, today, bclean, sync, etc.)
- SSH commit signing configuration
- Modern Git settings (rebase on pull, auto-prune, histogram diff)
- Platform-specific editor and tool configurations
- Custom color schemes

**Important:** The main `.gitconfig` uses `includeIf` to load platform-specific
               configs automatically.

### Line Endings

The repository includes a `.gitattributes` file that handles line endings:

- **LF** (Unix-style) for: shell scripts, Vim configs, Git configs
- **CRLF** (Windows-style) for: PowerShell scripts, batch files
- **Binary** for: fonts, images

This ensures files work correctly on both Windows and Linux without conflicts.

### PowerShell Profile

Located at `profile.ps1`, includes:

- Custom aliases (`g`, `py`, `pip`, `subl`)
- oh-my-posh with powerflow theme
- Terminal-Icons, PSReadLine

### Vim/Neovim Configuration

- **`.vimrc`** - Main Vim configuration
- **`nvim/init.lua`** - Neovim configuration with lazy.nvim plugin manager
- **`nvim/colors/solarized_true.vim`** - Solarized color scheme

### Windows Terminal

- `JetBrainsMono Nerd Font Mono` (installed via `setup.ps1 -InstallPackages`)
- Campbell PowerShell color scheme
- Opacity + acrylic background

### Fonts

JetBrainsMono Nerd Font is installed automatically via:

```pwsh
.\scripts\windows\setup.ps1 -InstallPackages
```
Which runs `oh-my-posh font install JetBrainsMono` after winget packages.

---

## Repository Structure

```
dotfiles/
├── .bashrc                         # Bash configuration (Linux)
├── .gitconfig                      # Main Git config (cross-platform)
├── .gitconfig-linux                # Linux-specific Git settings
├── .gitconfig-windows              # Windows-specific Git settings
├── .gitattributes                  # Line ending configuration
├── .gitignore                      # Git ignore rules
├── .vimrc                          # Vim configuration
├── i3wm-config                     # i3 window manager config (Linux)
├── profile.ps1                     # PowerShell profile
├── settings.json                   # Windows Terminal config
├── powerflow.omp.json              # oh-my-posh theme
├── Preferences.sublime-settings    # Sublime Text settings
├── links.json                      # Symlink definitions (dotmap-cli)
├── alacritty/
│   ├── alacritty.toml              # Base Alacritty config
│   ├── alacritty-linux.toml        # Linux overrides
│   └── alacritty-windows.toml      # Windows overrides
├── nvim/
│   ├── init.lua                    # Neovim configuration
│   └── colors/
│       └── solarized_true.vim      # Color scheme
├── polybar/
│   ├── config.ini                  # Polybar configuration
│   ├── launch_polybar.sh           # Polybar launch script
│   └── thermald-status.sh          # Temperature status script
├── rofi/
│   ├── config.rasi                 # Rofi configuration
│   └── catppuccin-mocha.rasi       # Catppuccin Mocha theme
├── fonts/
│   ├── FiraCode/
│   ├── SourceCodePro/
│   └── Terminus/
├── images/                         # Screenshots / assets
└── scripts/
    ├── windows/
    │   ├── setup.ps1               # Install packages + symlinks
    │   ├── firewall.ps1            # Hardening firewall inbound rules
    │   └── install_fonts.ps1       # Font installer
    └── linux/
        ├── pomodoro.sh
        ├── music.sh
        ├── thermald.sh
        └── kernel-trace-full.sh
```

---

## Usage

### Git Aliases

After installing, try these useful Git aliases:

```bash
git lg          # Beautiful commit graph
git hist        # Detailed history with dates
git today       # See today's commits
git st          # Short for status
git sync        # Fetch all and prune dead branches
git bclean      # Remove merged branches
git aliases     # List all available aliases
```

### PowerShell Aliases

Available after setup:

```powershell
g              # git
py             # python
pip            # python -m pip
subl           # sublime text (if installed)
```

### Customization

- **PowerShell:** Edit `profile.ps1` to add your own aliases and functions
- **Git:** Add personal aliases to `.gitconfig` under `[alias]` section
- **Vim:** Modify `.vimrc` for your preferred settings
- **Terminal:** Customize `settings.json` for colors and fonts

---

## Platform-Specific Notes

### Windows

- Run setup script as Administrator for best results
- Windows Terminal recommended over Command Prompt or PowerShell ISE
- oh-my-posh requires installation via `winget install JanDeDobbeleer.OhMyPosh`
- Fonts should be installed system-wide for terminal rendering

### Linux

- Ensure `~/.config/nvim/` directory exists before copying configs
- Install oh-my-posh via package manager or curl
- Nerd Fonts may need manual installation
- Some PowerShell features require PowerShell Core (pwsh)

---

## Troubleshooting

### PowerShell profile not loading

- Check profile location: `$PROFILE`
- Verify execution policy: `Get-ExecutionPolicy`
- Verify symlink was created correctly

### Fonts not displaying

- Ensure JetBrainsMono Nerd Font is installed
- Set font in Windows Terminal Settings -> Profile -> Appearance
- Restart terminal after font installation

### SSH commit signing issues

- Verify SSH key exists: `ls ~/.ssh/id_ed25519_signing`
- Check allowed_signers file exists: `cat ~/.ssh/allowed_signers`
- Test signing: `git commit --allow-empty -m "test" -S`

---

## Migration from Old Config

If you have existing dotfiles:

1. **Backup current configs:**
   ```bash
   cp ~/.gitconfig ~/.gitconfig.backup
   cp ~/.vimrc ~/.vimrc.backup
   ```

2. **Install new configs** following Quick Start instructions

3. **Merge custom settings:**
   - Review your backup files
   - Copy any custom aliases or settings to new configs
   - Test to ensure everything works

4. **Clean up:**
   ```bash
   rm ~/.gitconfig.backup
   ```

---

## Updates and Maintenance

### Pulling Latest Changes

```bash
cd ~/dotfiles
git pull origin main
```

### Rerunning Setup (Windows)

```powershell
.\scripts\windows\setup.ps1 -InstallPackages
```

This will update symlinks and reinstall packages if needed.

### Syncing Across Machines

After making changes on one machine:

```bash
git add -A
git commit -m "Update configurations"
git push
```

On other machines:

```bash
git pull
# Rerun setup script if needed
```

---

## Contributing

This is a personal dotfiles repository, but feel free to:

- Fork and adapt for your own use
- Submit issues if you find bugs
- Share your own dotfiles for inspiration

---

## License

This project is licensed under the MIT License.

```
MIT License

Copyright (c) 2025 Marko Trickovic

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## Acknowledgments

- [oh-my-posh](https://ohmyposh.dev) - Prompt theme engine
- [Nerd Fonts](https://www.nerdfonts.com) - Patched fonts with icons
- [Solarized](https://ethanschoonover.com/solarized/) - Color scheme
- [Vim](https://www.vim.org), [Neovim](https://neovim.io) and [Sublime Text 4](https://www.sublimetext.com) - Text editors

---

**Author:** Marko Trickovic
**GitHub:** [@mtrickovic](https://github.com/mtrickovic)
**Email:** marko@trickovic.dev

[badge-ps]: https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white
[badge-git]: https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white
[badge-wt]: https://img.shields.io/badge/Windows%20Terminal-4D4D4D?style=for-the-badge&logo=windows-terminal&logoColor=white
[badge-nvim]: https://img.shields.io/badge/Neovim-57A143?style=for-the-badge&logo=neovim&logoColor=white
[badge-license]: https://img.shields.io/badge/license-MIT-green?style=for-the-badge

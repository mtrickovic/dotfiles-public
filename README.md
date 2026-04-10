# Dotfiles Repository

![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)
![Windows Terminal](https://img.shields.io/badge/Windows%20Terminal-4D4D4D?style=for-the-badge&logo=windows-terminal&logoColor=white)
![Neovim](https://img.shields.io/badge/Neovim-57A143?style=for-the-badge&logo=neovim&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)

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
- **install_font.ps1** - Terminus font installer (Windows)

---

## Quick Start

### Windows Installation

```powershell
# Clone the repository
git clone https://github.com/mtrickovic/dotfiles-public dotfiles
cd dotfiles

# Run PowerShell as Administrator
# Allow script execution
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

# Run setup script
.\setup.ps1 -InstallPackages
```

### Linux Installation

```bash
# Clone the repository
git clone https://github.com/mtrickovic/dotfiles-public dotfiles
cd dotfiles

# Copy configuration files
cp .gitconfig ~/.gitconfig
cp .gitconfig-linux ~/.gitconfig-linux
cp .vimrc ~/.vimrc
cp -r nvim ~/.config/
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

The Git configuration is split into multiple files for cross-platform compatibility:

- **`.gitconfig`** - Main configuration (works on all platforms)
- **`.gitconfig-linux`** - Linux-specific overrides
- **`.gitconfig-windows`** - Windows-specific overrides

Features:
- 30+ useful aliases (lg, hist, today, bclean, sync, etc.)
- SSH commit signing configuration
- Modern Git settings (rebase on pull, auto-prune, histogram diff)
- Platform-specific editor and tool configurations
- Custom color schemes

**Important:** The main `.gitconfig` uses `includeIf` to load platform-specific configs automatically.

### Line Endings

The repository includes a `.gitattributes` file that handles line endings:

- **LF** (Unix-style) for: shell scripts, Vim configs, Git configs
- **CRLF** (Windows-style) for: PowerShell scripts, batch files
- **Binary** for: fonts, images

This ensures files work correctly on both Windows and Linux without conflicts.

### PowerShell Profile

Located at `profile.ps1`, includes:

- Custom aliases (g, py, pip, etc.)
- oh-my-posh integration with powerflow theme
- Terminal-Icons for pretty file listings
- PSReadLine configuration for better editing
- Enhanced ListView style

To activate: The setup script creates a symlink to your PowerShell profile location.

### Vim/Neovim Configuration

- **`.vimrc`** - Main Vim configuration
- **`nvim/init.vim`** - Neovim configuration (sources .vimrc)
- **`nvim/colors/solarized_true.vim`** - Solarized color scheme

Features:
- Line numbers and syntax highlighting
- Solarized dark theme
- UTF-8 encoding
- Unix line endings

### Windows Terminal

The `settings.json` includes:

- Custom color schemes
- Font configuration (works with Nerd Fonts)
- Default profile settings
- Keybindings

**Location:** Copy to `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3dbbwe\LocalState\`

---

## Repository Structure

```
dotfiles/
├── .gitconfig                 # Main Git config (cross-platform)
├── .gitconfig-linux          # Linux-specific Git settings
├── .gitconfig-windows        # Windows-specific Git settings
├── .gitattributes            # Line ending configuration
├── .vimrc                    # Vim configuration
├── profile.ps1               # PowerShell profile
├── setup.ps1                 # Windows setup script
├── install_font.ps1          # Font installer (Windows)
├── settings.json             # Windows Terminal config
├── powerflow.omp.json        # oh-my-posh theme
├── Preferences.sublime-settings  # Sublime Text settings
├── nvim/
│   ├── init.vim              # Neovim configuration
│   └── colors/
│       └── solarized_true.vim  # Color scheme
├── Terminus_TTF_Font_Family_(Fontmirror)/
│   └── *.ttf                 # Terminus font files
└── README.md                 # This file
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

### Git includeIf not working

- Ensure Git version is 2.13 or higher: `git --version`
- Check that platform-specific files exist in home directory
- Verify paths in `.gitconfig` match your system

### PowerShell profile not loading

- Check profile location: `$PROFILE`
- Verify execution policy: `Get-ExecutionPolicy`
- Ensure symlink was created correctly

### Fonts not displaying correctly

- Install a Nerd Font (e.g., FiraCode Nerd Font, Cascadia Code Nerd Font)
- Configure terminal to use the Nerd Font
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
.\setup.ps1 -InstallPackages
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

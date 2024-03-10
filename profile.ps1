# Set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

# Oh-My-Posh Theme
$omp_config = Join-Path $env:POSH_THEMES_PATH ".\powerflow.omp.json"
oh-my-posh init pwsh --config $omp_config | Invoke-Expression

# PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History

# Env
$env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"

# Alias
Set-Alias -Name vim -Value nvim
Set-Alias ll ls
Set-Alias g git
Set-Alias grep findstr
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias vim 'C:\Program Files\Neovim\bin\nvim.exe'
Set-Alias pdf 'C:\Program Files\Adobe\Acrobat DC\Acrobat\acrobat.exe'
Set-Alias gcc 'C:\Tools\mingw64\bin\gcc.exe'
Set-Alias make 'C:\Tools\gnuwin32\bin\make.exe'

# Sets the Python alias if it finds it installed
$pythonPaths = @(
    "$env:USERPROFILE\intelpython3\",
    'C:\Program Files (x86)\Intel\oneAPI\intelpython\latest\'
)

foreach($path in $pythonPaths) {
    $pythonExecutable = Join-Path $path "python.exe"
    $pipExecutable = Join-Path $path "Scripts/pip.exe"
    if (Test-Path $pythonExecutable) {
        Set-Alias python $pythonExecutable
        Set-Alias pip $pipExecutable
        break
    }
}

# Utilities
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

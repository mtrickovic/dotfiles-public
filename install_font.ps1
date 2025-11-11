$fonts = Get-ChildItem "$env:USERPROFILE\GH\dotfiles\Terminus_TTF_Font_Family_(Fontmirror)" -Filter *.ttf
foreach ($font in $fonts) {
    Copy-Item $font.FullName -Destination "$env:WINDIR\Fonts"
    $name = $font.BaseName
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" `
        -Name "$name (TrueType)" -PropertyType String -Value $font.Name -Force
}

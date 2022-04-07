# C:\Users\[userhome]\Documents\PowerShell\Microsoft.PowerShell_profile.ps1

function ConfigurePsProfile {
    Write-Output '>>> PowerShell profile configuration ($profile):'
    Write-Output $profile

    Write-Output "`n>>> Shift+Tab       TabCompletePrevious"
    Set-PSReadlineKeyHandler -Key Shift+Tab -Function TabCompletePrevious

    Write-Output '>>> Ctrl+Tab        TabCompleteNext        Default Tab behavior'
    Set-PSReadlineKeyHandler -Key Ctrl+Tab -Function TabCompleteNext

    Write-Output '>>> Tab             Complete               Bash behavior'
    Set-PSReadlineKeyHandler -Key Tab -Function Complete

    Set-PSReadlineOption -BellStyle None

    Write-Output '>>> Hint: shut down all WSL 2 VMs "wsl --shutdown"'

    Write-Output "`n### PowerShell functions:"
    Write-Output '## UpdateAll (alias Update-All) - updates Scoopt, Rust, PowerShell'
    Write-Output '## ScoopExport - exports currently installed Scoop apps into a file'
    Write-Output "## Audio -Url <youtube url> - downloads auto from YouTube`n"
}

function UpdateAll {
    Write-Output "`n>>> Updating Scoop and Scoop's packages..."
    scoop status
    scoop update
    scoop update *

    Write-Output "`n>>> Removing old Scoop packages..."
    scoop cleanup *
    Write-Output "`n>>> Cleaning old Scoop's cache..."
    scoop cache rm *

    UpdateRust
}

function UpdateRust {
    Write-Output "`n>>> Updating Rust..."
    Write-Output "RUSTUP_HOME: $env:RUSTUP_HOME"
    Write-Output "CARGO_HOME: $env:CARGO_HOME"
    rustup update
    rustup --version
    rustc --version
    cargo --version
}

function ScoopExport {
    (scoop export) | sls '^([\w-]+)' | % { $_.matches.groups[1].value } > scoop-apps.txt
}

function ScoopImport {
    scoop bucket add extras
    scoop bucket add java
    scoop bucket add nonportable

    $apps = gc scoop-apps.txt
    scoop install @apps
}

function Audio {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Url
    )

    Write-Output "$Url"
    youtube-dl --extract-audio --format bestaudio --audio-format mp3 $Url
}

New-Alias -Name Update-All -Value UpdateAll
try {
    $null = gcm pshazz -ea stop; pshazz init
}
catch {
}

ConfigurePsProfile

Set-Location D:/workspace

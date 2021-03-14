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
    UpdateAzPowerShell
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

function UpdateAzPowerShell {
    Write-Output "`n>>> Updating Az PowerShell modules..."
    Update-Module -Name Az -Verbose
}

function ScoopExport {
    (scoop export) | sls '^([\w-]+)' | % { $_.matches.groups[1].value } > scoop-apps.txt
}

function ScoopImport {
    $apps = gc scoop-apps.txt
    scoop install @apps
}

New-Alias -Name Update-All -Value UpdateAll
try { $null = gcm pshazz -ea stop; pshazz init } catch { }

ConfigurePsProfile

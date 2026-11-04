[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [ValidateSet('Project', 'User')]
    [string]$Scope = 'Project',
    [string]$ProjectPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$sourceRoot = [System.IO.Path]::GetFullPath($PSScriptRoot)
if ($Scope -eq 'Project') {
    if ([string]::IsNullOrWhiteSpace($ProjectPath)) {
        throw 'Project scope requires -ProjectPath pointing to an existing project.'
    }
    $projectItem = Get-Item -LiteralPath $ProjectPath
    if (-not $projectItem.PSIsContainer) {
        throw 'ProjectPath must be a directory.'
    }
    $targetRoot = Join-Path $projectItem.FullName '.agents/skills'
} else {
    if (-not [string]::IsNullOrWhiteSpace($ProjectPath)) {
        throw '-ProjectPath is only valid with -Scope Project.'
    }
    $profileRoot = [Environment]::GetFolderPath('UserProfile')
    if ([string]::IsNullOrWhiteSpace($profileRoot)) {
        throw 'Cannot resolve the user profile directory.'
    }
    $targetRoot = Join-Path $profileRoot '.agents/skills'
}
$targetRoot = [System.IO.Path]::GetFullPath($targetRoot)
$separator = [System.IO.Path]::DirectorySeparatorChar
$sourcePrefix = $sourceRoot.TrimEnd($separator) + $separator
$targetPrefix = $targetRoot.TrimEnd($separator) + $separator
if ($sourceRoot -eq $targetRoot -or
    $targetRoot.StartsWith($sourcePrefix, [StringComparison]::OrdinalIgnoreCase) -or
    $sourceRoot.StartsWith($targetPrefix, [StringComparison]::OrdinalIgnoreCase)) {
    throw 'Source and installation directories must not overlap.'
}

$skillFolders = @(Get-ChildItem -LiteralPath $sourceRoot -Directory |
    Where-Object { $_.Name -like 'sk-*' -and (Test-Path -LiteralPath (Join-Path $_.FullName 'SKILL.md') -PathType Leaf) } |
    Sort-Object Name)
if ($skillFolders.Count -eq 0) {
    throw 'No skill folders were found next to this installer.'
}

# Check all collisions before making any changes. Existing different versions
# must be reviewed by the user; the installer never deletes or overwrites them.
$pending = @()
$unchanged = @()
foreach ($skillFolder in $skillFolders) {
    $sourceFiles = @(Get-ChildItem -LiteralPath $skillFolder.FullName -Recurse -File)
    if (@(Get-ChildItem -LiteralPath $skillFolder.FullName -Recurse -Force |
        Where-Object { $_.Attributes -band [IO.FileAttributes]::ReparsePoint }).Count -gt 0) {
        throw "Skill source contains a reparse point: $($skillFolder.FullName)"
    }
    $destination = Join-Path $targetRoot $skillFolder.Name
    if (-not (Test-Path -LiteralPath $destination)) {
        $pending += [pscustomobject]@{ Source = $skillFolder.FullName; Target = $destination; Name = $skillFolder.Name }
        continue
    }
    $destinationItem = Get-Item -LiteralPath $destination -Force
    if (-not $destinationItem.PSIsContainer -or
        ($destinationItem.Attributes -band [IO.FileAttributes]::ReparsePoint)) {
        throw "Conflicting installation path: $destination"
    }
    $destinationFiles = @(Get-ChildItem -LiteralPath $destination -Recurse -Force -File)
    $identical = ($sourceFiles.Count -eq $destinationFiles.Count)
    foreach ($sourceFile in $sourceFiles) {
        $relativePath = $sourceFile.FullName.Substring($skillFolder.FullName.Length + 1)
        $installedFile = Join-Path $destination $relativePath
        if (-not (Test-Path -LiteralPath $installedFile -PathType Leaf)) {
            $identical = $false
            break
        }
        if ((Get-FileHash -LiteralPath $sourceFile.FullName -Algorithm SHA256).Hash -ne
            (Get-FileHash -LiteralPath $installedFile -Algorithm SHA256).Hash) {
            $identical = $false
            break
        }
    }
    if (-not $identical) {
        throw "Existing skill differs: $destination. Compare and move that skill aside before retrying. No files were changed."
    }
    $unchanged += $skillFolder.Name
}

$installed = 0
foreach ($item in $pending) {
    if ($PSCmdlet.ShouldProcess($item.Target, "Install $($item.Name)")) {
        New-Item -ItemType Directory -Path $targetRoot -Force | Out-Null
        Copy-Item -LiteralPath $item.Source -Destination $item.Target -Recurse
        $installed++
        Write-Output "Installed: $($item.Name)"
    }
}
Write-Output "Installed $installed skill(s); unchanged $($unchanged.Count); destination: $targetRoot"

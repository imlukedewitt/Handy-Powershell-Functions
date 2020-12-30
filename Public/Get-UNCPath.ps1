<#
.SYNOPSIS
    Replaces named drive letters with UNC paths
.DESCRIPTION
    By default, Get-UNCPath will return the UCN path of the running script. Other paths can be specified.
.EXAMPLE
    PS C:\> Get-UNCPath -Path "X:\OtherScript.ps1"
    \\XDrive.company.com\OtherScript.ps1
.EXAMPLE
    PS C:\> Get-UNCPath -Quotes -ScriptRoot
    "\\Networkdrive.company.com\Directory"
#>

function Get-UNCPath
{
    param
    (
        [switch]$ScriptRoot,
        [switch]$Quotes,
        [string]$Path = $script:MyInvocation.MyCommand.Path
    )

    if ($Path.contains([io.path]::VolumeSeparatorChar))
    {
        $psDrive = Get-PSDrive -Name $Path.Substring(0,1) -PSProvider FileSystem
        if ($psDrive.DisplayRoot) { $Path = $Path.Replace($psDrive.Name + [io.path]::VolumeSeparatorChar, $psDrive.DisplayRoot) }
    }

    if ($ScriptRoot) { $Path = Split-Path -Parent $Path}
    if ($Quotes) { $Path = '"' + $Path + '"' }
    return $Path
}
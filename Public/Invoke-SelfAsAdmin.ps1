<#
.SYNOPSIS
    Function to self-elevate a powershell script
.DESCRIPTION
    Invoke-SelfAsAdmin checks the path of the running script, replaces any named network drives with their UNC paths, and then re-launches the script in a new process.
.EXAMPLE
    PS C:\> Invoke-SelfAsAdmin
#>

function Invoke-SelfAsAdmin
{
    ## Replace named network path with UNC path if necessary
    $path = $script:MyInvocation.MyCommand.Path
    if ($path.contains([io.path]::VolumeSeparatorChar))
    {
        $psDrive = Get-PSDrive -Name $path.Substring(0,1) -PSProvider FileSystem
        if ($psDrive.DisplayRoot) { $path = $path.Replace($psDrive.Name + [io.path]::VolumeSeparatorChar, $psDrive.DisplayRoot) }
    }
    
    ## Re-open script as administrator if necessary
    $adminAccess = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
    if (!$adminAccess)
    {
        Start-Process Powershell -Verb RunAs -ArgumentList "-NoLogo -NoProfile -ExecutionPolicy Bypass -File `"$path`""
        Exit
    }
}
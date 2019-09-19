function RunAsAdmin
{
    # Usage:
    # if (RunAsAdmin) { [do whatever] }

    $adminaccess = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')
    if ($adminaccess) { return $true}
    $argList = @("-NoLogo -ExecutionPolicy Bypass -File $(Get-UNCPath -Quotes)" )
    Start-Process Powershell.exe -Verb Runas -ArgumentList $argList
    exit 0
}

function Get-UNCPath
{
    param ( [switch]$ScriptRoot, [switch]$Quotes )

    $path = $script:MyInvocation.MyCommand.Path
    if ($path.contains([io.path]::VolumeSeparatorChar))
    {
        $psDrive = Get-PSDrive -Name $path.Substring(0,1) -PSProvider FileSystem
        if ($psDrive.DisplayRoot) { $path = $path.Replace($psDrive.Name + [io.path]::VolumeSeparatorChar, $psDrive.DisplayRoot) }
    }

    if ($ScriptRoot) { $path = $path.Replace([io.path]::DirectorySeparatorChar + $script:MyInvocation.MyCommand.Name, "") }
    if ($Quotes) { $path = '"' + $path + '"' }
    return $path
}
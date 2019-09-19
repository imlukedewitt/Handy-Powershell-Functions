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

function Get-IniConfig
    {
        # Parses the config file and returns an array of the desired settings section
        # To use, define $config as such: $config = Get-Content [path to config.ini]

        param
        (
            [Parameter(Position=0, Mandatory=$true)]
            [String]$Section
        )
        
        $startIndex = $config | Select-String -Pattern "\[$Section\]" | Select-Object -ExpandProperty LineNumber
        $sectionLength = $config[$startIndex..$config.Length] | Select-String -Pattern "\[*\]" | Select-Object -First 1 -ExpandProperty LineNumber
        if (!$sectionLength) { $sectionLength = $config.Length - $startIndex + 1}
        return $config[$startIndex..($startindex + $sectionLength - 2)] | Where-Object { $_.trim() -ne "" -and $_.trim() -notmatch "^;" }
    }
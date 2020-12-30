<#
.SYNOPSIS
    Test all GPOs for regex query. Requires GroupPolicy Powershell module.
#>

function Search-GPOsForString
{
    #Requires -Module GroupPolicy

    param
    (
        [Parameter(Mandatory=$true)][string]$RegexQuery,
        [switch]$Pause
    )

    Get-GPO -All |
        Where-Object { $_ | Get-GPOReport -ReportType Xml | Select-String $RegexQuery } |
        Select-Object -ExpandProperty DisplayName
}
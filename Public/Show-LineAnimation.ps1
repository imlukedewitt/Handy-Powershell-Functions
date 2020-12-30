<#
.SYNOPSIS
    Displays an animation while a scriptblock completes
.EXAMPLE
    PS C:\> Show-LineAnimation -ScriptBlock { Start-Sleep 5 }
    Plays the animation for 5 seconds while Start-Sleep completes in the background
#>

function Show-LineAnimation
{
    param
    (
        [Parameter(Mandatory = $true)]
        [scriptblock]$ScriptBlock
    )

    $jobby = Start-Job -ScriptBlock $ScriptBlock

    $animation = ">--------------","<>-------------","-<>------------","---<>----------","-------<>------","----------<>---","------------<>-","-------------<>","--------------<","-------------<>","------------<>-","----------<>---","-------<>------","---<>----------","-<>------------","-<>------------","<>-------------"
    $animationIndex = 0
    while (($jobby.State -eq "Running") -and ($jobby.State -ne "NotStarted"))
    {
        write-host "`r$($animation[$animationIndex])" -NoNewline
        $animationIndex += 1
        if ($animationIndex -eq $animation.Length)
        {
            $animationIndex = 0
        }
        start-sleep -Milliseconds 70
    }
    Write-Host "`r                  `n"
}
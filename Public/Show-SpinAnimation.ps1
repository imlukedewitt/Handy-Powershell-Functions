<#
.SYNOPSIS
    Displays an animation while a scriptblock completes
.EXAMPLE
    PS C:\> Show-SpinAnimation -ScriptBlock { Start-Sleep 5 }
    Plays the animation for 5 seconds while Start-Sleep completes in the background
#>

function Show-SpinAnimation
{
    param
    (
        [Parameter(Mandatory = $true)]
        [scriptblock]$scriptblock
    )

    $jobby = Start-Job -ScriptBlock $scriptblock

    $animation = "| ","/ ","- ","\ "
    $animationIndex = 0
    while (($jobby.State -eq "Running") -and ($jobby.State -ne "NotStarted"))
    {
        write-host "$($animation[$animationIndex])" -NoNewline
        $animationIndex += 1
        if ($animationIndex -eq $animation.Length)
        {
            $animationIndex = 0
        }
        [console]::SetCursorPosition($([console]::CursorLeft - 2),$([console]::CursorTop))
        start-sleep -Milliseconds 120
    }
    Write-Host "  `n"
}
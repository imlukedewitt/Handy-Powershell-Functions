<#
.SYNOPSIS
    Animates a text block onto the console
.DESCRIPTION
    Instead of writing a text block one row at a time, Show-TextBlockAnimation writes text one column at a time.
.EXAMPLE
    PS C:\> Show-TextBlockAnimation "Hello`nHow are you today?`n"
#>

function Show-TextBlockAnimation
{
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$string
    )

    [console]::CursorVisible = $false
    function cursorUp {[console]::SetCursorPosition([console]::CursorLeft,[console]::CursorTop - 1)}
    function cursorRight {[console]::SetCursorPosition([console]::CursorLeft + 1,[console]::CursorTop)}
    function cursorDown {[console]::SetCursorPosition([console]::CursorLeft,[console]::CursorTop + 1)}
    function cursorLeft {[console]::SetCursorPosition([console]::CursorLeft - 1,[console]::CursorTop)}

    $lines = $string.Split("`n")
    for ($i=0; $i -lt $lines.Length; $i++)
    {
        Write-Host "`n" -NoNewline
    }
    for(($i=0), ($h=$lines.Length); $i -lt ($lines | Measure-Object -Maximum -Property Length).Maximum; $i++)
    {
        if ($h -eq $lines.Length)
        {
            foreach ($item in $lines)
            {
                cursorUp
            }   
            $h = 0
        }
        $temp = @()
        for ($j=0; $j -lt $lines.Length; $j++)
        {
            if ($lines[$j][$i]) {$temp += $lines[$j][$i]}
            else {$temp += $false}
        }
        foreach ($char in $temp)
        {
            if($char)
            {
                Write-Host -NoNewline $char
                cursorLeft
            }
            cursorDown
            $h++
        }
        Start-Sleep -Milliseconds 20
        cursorRight
        
        
        if ($temp[0] -or $temp[1]) {$mixed += , @($temp)}
    }
    Write-Host
    [console]::CursorVisible = $true
}
# It's the little things.

function animation
{
    param
    (
        [Parameter(Mandatory = $true)]
        [scriptblock]$scriptblock
    )

    $jobby = Start-Job -ScriptBlock $scriptblock

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
function writeString
{
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$string,
        [string]$color = "White",
        [switch]$noNewLine
    )

    [char[]]$string | ForEach-Object `
    {
        Write-Host -NoNewline -ForegroundColor $color $_
        Start-Sleep -Milliseconds 5
    }
    if (!($noNewLine)) {Write-Host}
}

function spinner
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

function cursor
{
    param
    (
        [switch]$show,
        [switch]$visible,
        [switch]$hide,
        [switch]$invisible
    )

    if ($show -or $visible)   {[console]::CursorVisible = $true}
    if ($hide -or $invisible) {[console]::CursorVisible = $false}
}

function write-block
{
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$string
    )
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
}

cursor -hide
animation -scriptblock {Start-Sleep 3}
writeString -color green "A Reading from the Book of Armaments, Chapter 4, Verses 16 to 20:"
""
writeString -color yellow 'Then did he raise on high the Holy Hand Grenade of Antioch, saying, "Bless this, O Lord, that with it thou mayst blow thine enemies to tiny bits, in thy mercy." And the people did rejoice and did feast upon the lambs and toads and tree-sloths and fruit-bats and orangutans and breakfast cereals ... Now did the Lord say, "First thou pullest the Holy Pin. Then thou must count to three. Three shall be the number of the counting and the number of the counting shall be three. Four shalt thou not count, neither shalt thou count two, excepting that thou then proceedeth to three. Five is right out. Once the number three, being the number of the counting, be reached, then lobbest thou the Holy Hand Grenade in the direction of thine foe, who, being naughty in my sight, shall snuff it."'
spinner -scriptblock {Start-Sleep 3}
cursor -show

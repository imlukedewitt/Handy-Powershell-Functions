function Write-StringAsAnimation
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
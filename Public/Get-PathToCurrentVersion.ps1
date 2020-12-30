<#
.SYNOPSIS
    Finds the most recent version of an installer in a folder structure
    Written by Luke
.DESCRIPTION
    Searches a given directory for the subdirectory with the highest numbered
    name and returns the UNC path of the EXE/MSI file within that subdirectory.

    The script returns MSI and EXE files by default. You can specify a customize/limit the file type with the -Extension paramter
    The optional paramter -Containing will only return files that contain the text specified
    The switch -Quotes will return the filepath as a string enclosed in single-quotes.

    NOTICE: This function won't work if version number doesn't contain a dot and is less than 3 characters.
    It can also fail if the version number contains more than 3 dots.
.EXAMPLE
    PS>  Get-PathToCurrentVersion -RootFolder "T:\Applications\SomeSoftware" -Quotes
    '\\Storage.mssu.edu\Software\Applications\SomeSoftware\4.21.0\SomeSoftware.MSI'

    PS>  Get-PathToCurrentVersion -RootFolder "T:\Applications\Othersoftware" -Containing "x64" -Extension '.PS1'
    \\Storage.mssu.edu\Software\Applications\Othersoftware\10.1.2-x64.PS1
#>

function Get-PathToCurrentVersion
{
    ##: Define parameters
    param
    (
        [parameter(Mandatory=$true)]
        [Alias("Root","Folder")]
        [string]$RootFolder,
        [String[]]$Extension = @('.exe','.msi'),
        [String]$Containing = "",
        [switch]$Quotes
    )
    
    # ##: Replace mapped network drive letters with UNC paths
    $RootFolder = Get-UNCPath $RootFolder

    ##: Search directory for matching installers. Uses Regex to sort by version number in file name
    ##: Function won't work if version number doesn't contain a dot and is less than 3 characters
    ##: This doesn't work 100% reliably so you need to check it per software.
    $installerPath = Get-ChildItem $RootFolder -Recurse |
        Where-Object { $Extension -contains $_.Extension} |
        Where-Object { $_ -like "*$Containing*" } |
        Sort-Object -Property @{Expression={
            $version = [regex]::Match($_.Name, "(\d+\.?){2,}\d+").Value
            if ($version -match '\.') { [version]$version }
            else { [version]"$version.0" }
        }} |
        Select-Object -Last 1 -ExpandProperty FullName
    
    if (!$installerPath) { throw "No matching installers were found. Please check your path/extension parameters`n"}
    if ($Quotes) {return "'$installerPath'"} else {return $installerPath}
}
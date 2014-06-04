function setData
{
    $folderPath = ($env:USERPROFILE + "\Desktop\TestingThings\")

    Write-Host $folderPath




}


function copyFolderInPath($path) 
{
    $folderName = "original"
    
    Get-ChildItem -Path $path | Where { $_.PSIsContainer -eq $true -and $_.Name -ne $folderName} | Foreach {

    Remove-Item -Recurse -Force $_.FullName
   }
}

#
#	Main Program
#

setData

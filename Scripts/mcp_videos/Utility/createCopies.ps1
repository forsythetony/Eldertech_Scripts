function setData
{
    $folderPath = ($env:USERPROFILE + "\Desktop\TestingCopies\")

    if (Test-Path $folderPath)
    {
    	Write-Host ("The folder " + $folderPath + " does exist.")
    }
    else
    {
    	Write-Host ("The folder " + $folderPath + " does not exist.")
    }
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

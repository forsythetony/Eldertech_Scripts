function setData
{
    $folderPath = ""




}


function copyFolderInPath($path) 
{
    $folderName = "original"
    
    Get-ChildItem -Path $path | Where { $_.PSIsContainer -eq $true -and $_.Name -ne $folderName} | Foreach {

    Remove-Item -Recurse -Force $_.FullName
   }
}

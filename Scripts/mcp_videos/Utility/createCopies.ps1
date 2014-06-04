function setData
{
    $folderPath = ($env:USERPROFILE + "\Desktop\TestingCopies\")
    $foldersToCreate = 10
    $newFolderName = "testing"
    $originalName = "original\*"
    $originalFolderPath = ($folderPath + $originalName)

    $error = $null

    if(Test-Path $folderPath) {$en1 = $folderPath} else {$en1 = $null}
    if(Test-Path $originalFolderPath) {$en2 = $originalFolderPath} else {
    	$en2 = $null
    	$error = "The folder could not be found"
    }

    $finalDict = @{
    	"folderDirectory" = $en1;
    	"folderName" = $newFolderName;
    	"foldersCount" = $foldersToCreate;
    	"originalPath" = $originalFolderPath; 
    	"error" = $error;
    }

    # Write-Host ("The folder directory is " + $finalDict.folderDirectory + " The folder name is " + $finalDict.folderName + " The folders count is " + $finalDict.foldersCount + " The original name is " + $finalDict.originalName + " The error is " + $finalDict.error)

    return $finalDict
}

function copyFolder($data)
{
	Write-Host $data.originalPath

	for( $i = 1; $i -le $data.foldersCount; $i++)
	{
		$folderName = ($data.folderName + $i)

		$newFolderPath = ($data.folderDirectory + $folderName)

		if(Test-Path $newFolderPath)
		{
			Remove-Item -Recurse -Force $newFolderPath
		}
		
		New-Item -ItemType directory -Path $newFolderPath

		Copy-Item $data.originalPath $newFolderPath
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

$userData = setData

copyFolder $userData



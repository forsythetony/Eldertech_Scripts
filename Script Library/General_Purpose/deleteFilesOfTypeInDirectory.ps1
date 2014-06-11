function getUserInput
{
    $pathToFolder = Read-Host "Enter the path to the folder you wish to delete files from"

    while( (Test-Path $pathToFolder) -ne $true)
    {
        $pathToFolder = Read-Host "Invalid path. Please re-enter the path."
    }

    # Ask user for the type of file to delete

    $fType = Read-Host "Enter the file type to delete"

    $fType = checkFileType $fType

    while ($fType -eq $null)
    {
        $fType = Read-Host "Invalid file type. Please enter again"

        $fType = checkFileType $fType
    }

    $userInput = @{ "path" = $pathToFolder;
                    "type" = $fType;
                    }


    return $userInput
}

function checkFileType($fileType)
{
    if (($fileType -eq "avi") -or ($fileType -eq "AVI") -or ($fileType -eq ".avi") -or ($fileType -eq ".AVI"))
    {
        return ".avi"
    }

    if (($fileType -eq "mp4") -or ($fileType -eq "MP4") -or ($fileType -eq ".MP4") -or ($fileType -eq ".mp4"))
    {
        return ".mp4"
    }

    return $null
}

function deleteFiles($userInput)
{
    Write-Host $userInput.path
    Write-Host $userInput.type
 # | Where {$_.PSIsDirectory -eq $false -and $_.Extension -eq $userInput.type} |

    Get-ChildItem -Path $userInput.path -Recurse | Where {$_.Extension -eq $userInput.type} | ForEach-Object {
        
        $deleteMessage = ("The file " + $_.Name + " is being deleted")


        Write-Host $deleteMessage

        Remove-Item -Path $_.FullName
    }
}

#
# Main Program
#

$userInput = getUserInput

deleteFiles $userInput



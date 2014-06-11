﻿function getUserInput
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
    $aviNames = "avi", "AVI", ".avi", ".AVI"
    $mp4Names = "mp4", "MP4", ".MP4", ".mp4"


    foreach ($nameString in $aviNames)
    {
        if($nameString -eq $fileType)
        {
            return ".avi"
        }
    }

    foreach ($nameString in $mp4Names)
    {
        if($nameString -eq $fileType)
        {
            return ".mp4"
        }
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
function testingFunction($var1)
{
    $fileType = Read-Host "Enter the file type to check"

    $fileType = checkFileType $fileType

    if($fileType -ne $null)
    {
        $successMessage = ("The fileType -> " + $fileType + " was found!")

        Write-Host $successMessage
    }
    else
    {
        $errorMessage = ("The fileType -> " + $fileType + " could not be found...")

        Write-Host $errorMessage
    }
}
#
# Main Program
#

<##
$userInput = getUserInput

deleteFiles $userInput
##>

testingFunction "HiS"


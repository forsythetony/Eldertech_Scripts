function getUserInput
{
    $pathToFiles = Read-Host "Enter the path to the folder containing the markdown files to be converted"

    while((Test-Path $pathToFiles) -eq $false)
    {
        $pathToFiles = Read-Host "Invalid path provided. Let's try that again."
    }

    $recurseBool = Read-Host "Do you want to find files recursively? 'yes' or 'no'"

    $recurseCheck = checkYesNoOption $recurseBool

    while($recurseCheck -eq $null)
    {
        $recurseBool = Read-Host "Invalid Input. Let's try that again. Enter yes or no"
        $recurseCheck = checkYesNoOption $recurseBool
    }

    $userInput = @{ "path" = $pathToFiles;
                    "recurse" = $recurseCheck;
                    }

    if ($userInput.recurse)
    {
        $recurseString = ""
    }
    else
    {
        $recurseString = "not"
    }

    $confirmMessage = ("The script will convert markdown files in folder " + $userInput.path + " and will " + $recurseString + " recurse.")
    
    Write-Host $confirmMessage

    $confirmBool = Read-Host "Enter 'yes' to continue or 'no' to quit."

    $confirmChecked = checkYesNoOption $confirmBool

    while($confirmChecked -eq $null)
    {
        $confirmBool = Read-Host "Invalid input. Let's try that again. Enter 'yes' to continue or 'no' to quit"
        $confirmChecked = checkYesNoOption $confirmBool
    }
    
    if($confirmChecked)
    {
        return $userInput
    }
    else
    {
        Exit
    }
}
function checkYesNoOption($recurseBool)
{
    $yesNames = "yes", "YES", "y"
    $noNames = "no", "NO", "n"

    foreach ($stringName in $yesNames)
    {
        if ($stringName -eq $recurseBool)
        {
            return $true
        }
    }

    foreach ($stringName in $noNames)
    {
        if($stringName -eq $recurseBool)
        {
            return $false
        }
    }

    return $null
}

$userInput = getUserInput

Write-Host "All Good"
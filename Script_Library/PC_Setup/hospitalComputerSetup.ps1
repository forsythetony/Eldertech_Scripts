# Set computer number and prefix

# $compNumber = "999"

# $oldCompNumber = "10000"
# $compPrefix = "10"

# Create actual computer number
# $compNumber = ($compPrefix) + ($compNumber)

# renameKinectDataFiles $compNumber $oldCompNumber

# Hash table with user input variables

#$userInputData = getUserData
#renameKinectDataFiles $userInputData

$userInputData = TestData
TestFunction $userInputData

function TestFunction
{
    param($inputDict)

   

}
function TestData
{
# Get the old computer number from the user
    
    $oldCompNumber = "10000"


    # Get the new computer number from the user
    
    $newComputerPrefix = "20"

    $compNumber = "999"


    # Get the date and time from the user

    $userDate = "6/22/1993"

    $userTime = "2:45 PM"

    $currentDateTime = $userDate + " " + $userTime

    $a = [datetime]::ParseExact($currentDateTime, "M/d/yyyy h:m tt", $null)


    # Create and return the hash table

    $userDataTable = @{ "Date" = $a;
                        "ComputerNumber" = $compNumber;
                        "OldComputerNumber" = $oldCompNumber;
                        "OldPrefix" = $computerPrefix;
                        "NewPrefix" = $newComputerPrefix}


    return $userDataTable
}

function getUserData
{
   
    # Get the old computer number from the user
    
    $oldCompNumber = Read-Host "Enter the 5 digit old computer number (In most cases this will be the default '10000')"


    # Get the new computer number from the user
    
    $newComputerPrefix = Read-Host "Enter the 2 digit new prefix"

    $compNumber = Read-Host "Enter the 3 digit computer number"


    # Get the date and time from the user

    $userDate = Read-Host "Enter the date in the format M/d/YYYY (ex. 4/22/2014)"

    $userTime = Read-Host "Enter the current time hh:mm:ss PM/AM (ex. 9:23 PM)"

    $currentDateTime = $userDate + " " + $userTime

    $a = [datetime]::ParseExact($currentDateTime, "M/d/yyyy h:m tt", $null)


    # Create and return the hash table

    $userDataTable = @{ "Date" = $a;
                        "ComputerNumber" = $compNumber;
                        "OldComputerNumber" = $oldCompNumber;
                        "OldPrefix" = $computerPrefix;
                        "NewPrefix" = $newComputerPrefix}


    return $userDataTable
}

function renameKinectDataFiles
{
    param($inputDict)
        
    $folderExtension = "\Desktop\Kinect"
    
    $folderPath = "$env:userprofile" + ($folderExtension)
    
    Write-Host $folderPath

    if(Test-Path $folderPath)
    {
        Write-Host "The folder exists"
    }
    else
    {
        Write-Host "Couldn't find the folder"
    }
    
    $configPath = ($folderPath) + "\config.txt"
    
    Write-Host $configPath
    
    if(Test-Path $configPath)
    {
        Write-Host "The config file exists"
    }
    else
    {
        Write-Host "The config file does not exist"
    }
    
    Write-Host $configPath
    
    # Change a line in the config file
    $prefix = "-SALERTS"
    
    $regexString = "^" + ($prefix) + ".+$"
    
    (Get-Content ($configPath)) | Foreach-Object {$_ -replace $regexString , ($prefix + " " + ($inputDict.NewPrefix) + ($inputDict.ComputerNumber))} | Set-Content ($configPath)
    
     
    # Rename the shortcut file
    
    $exePath = $folderPath + "\" + ($inputDict.OldComputerNumber) + "-Kinect.lnk"
    $newExeName = $folderPath + "\" + ($inputDict.NewPrefix) + ($inputDict.ComputerNumber) + "-Kinect.lnk"
    
    Write-Host $exePath
    Write-Host $newExeName

    if (Test-Path $exePath)
    {
        Write-Host "The Kinect shortcut was found"
    }
    else
    {
        Write-Host "The Kinect shortcut was not found"
    }

    Move-Item -LiteralPath $exePath -Destination $newExeName

    # Change the MountElektro.bat file
    
    $filePath = $folderPath + "\MountElektro.bat"

    $regexString = "hospitals/mu-hospital/" + ($inputDict.OldComputerNumber)
    $replacementString = "hospitals/mu-hospital/" + ($inputDict.NewPrefix) + ($inputDict.ComputerNumber)

    Write-Host ("The replacement string is:    " + $replacementString)
    Write-Host ("The search string is:      " + $regexString)


    (Get-Content ($filePath)) | Foreach-Object {$_ -replace $regexString , ($replacementString)} | Set-Content ($filePath)


    # Set the current date and time

    Set-Date $inputDict.Date


    # Rename the shortcut in start menu
    
    $folderPath = "\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"

    $exePath = $folderPath + "\" + ($inputDict.OldComputerNumber) + "-Kinect.lnk"
    $newExePath = $folderPath + "\" + ($inputDict.NewPrefix) + ($inputDict.ComputerNumber) + "-Kinect.lnk"

    Move-Item -LiteralPath $exePath -Destination $newExePath


    # Unmount and remount the z: drive

    umount z:

    %userprofile%\Desktop\Kinect\MountElektro.bat




}
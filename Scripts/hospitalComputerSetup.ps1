# Set computer number and prefix

$compNumber = "999"

$oldCompNumber = "10000"
$compPrefix = "10"

# Create actual computer number
$compNumber = ($compPrefix) + ($compNumber)

renameKinectDataFiles $compNumber $oldCompNumber



function renameKinectDataFiles
{
    param($compNumber,
        $oldCompNumber)
        
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
    
    (Get-Content ($configPath)) | Foreach-Object {$_ -replace $regexString , ($prefix + " " + $compNumber)} | Set-Content ($configPath)
    
     
    # Rename the shortcut file
    
    $exePath = $folderPath + "\" + $oldCompNumber + "-Kinect.lnk"
    $newExeName = $folderPath + "\" + $compNumber + "-Kinect.lnk"
    
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


    # Set the current date and time
    
    $confirmation = "n"


    $currentDate = Read-Host "Enter current date M/d/YYYY"

    $currentTime = Read-Host "Enter the current time hh:mm:ss PM/AM (ex. 9:23:00 PM)"

    $currentDateTime = $currentDate + " " + $currentTime

    Write-Host $currentDateTime

    $a=[datetime]::ParseExact($currentDateTime, "M/d/yyyy h:m tt", $null)
        
    Write-Host $a

    Set-Date $a

}
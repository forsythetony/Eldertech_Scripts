# Set computer number and prefix

$compNumber = "045"

$oldCompNumber = 100000
$compPrefix = "100"

# Create actual computer number
$compNumber = ($compPrefix) + ($compNumber)

renameKinectDataFiles $compNumber $oldCompNumber



function renameKinectDataFiles($compNumber, $oldCompNumber)
{
    $folderPath = "$env:userprofile\Desktop\testFiles"
    
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
    $prefix = "ALERTS"
    
    $regexString = "^" + ($prefix) + ".+$"
    
    (Get-Content ($configPath)) | Foreach-Object {$_ -replace $regexString , ($prefix + " - " + $compNumber)} | Set-Content ($configPath)
    
     
    # Rename the executable file
    
    $exePath = $folderPath + "\kinect-" + $oldCompNumber + ".exe" 
    $newExeName = $folderPath + "\kinect-" + $compNumber + ".exe"
    
    Rename-Item $exePath $newExeName
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
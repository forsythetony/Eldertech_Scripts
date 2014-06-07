#
#   Function Name: getUserData
#
#   Inputs: None
#
#   Output:
#       -$userData: A dictionary containing the entries...
#           - "start"     ->    A dateTime object that marks the start of the date range
#           - "end"       ->    A dateTime object that marks the end of the date range
#           - "folderPath"->    A path (string) object containing the folderpath to the folder containing the subfolder "KinectData"
#
#   Purpose: To gather input from the user to know which videos this script should convert
#
function getUserData
{
    Do {
        $rootPath = Read-Host "Enter the path to the folder containing video files (NOT /userid)"
        # $rootPath = "C:\Users\muengrcerthospkinect\Desktop\testing"
 
        $pathTest = Test-Path $rootPath
 
        if (!$pathTest) { Write-Host "Path provided was not valid, try again." }
        } while ($pathTest -eq $false)
 
       
 
    Do {
        $userID = Read-Host "Enter the userID (Enter all to search all files)"
 
        $isValidID = checkUserIDString $userID
       
        
        Write-Host $isValidID.message
 
        $userID = $isvalidID.path
 
        } while ($isValidID.isValid -eq $false)
 
    $rootPathLength = $rootPath.length - 1
 
    if($rootPath[$rootPathLength] -ne "\")
    {
        $rootPath = "$rootPath\"
    }
 
    $folderPath = ($rootPath + $userID);
 
 
    $startDate = Read-Host "Enter the start date for the date range in the format M/d/YYYY h:m AM/PM"
    # $startDate = "5/20/2013"
    $endDate = Read-Host "Enter the end date for the date range in the format M/d/YYYY h:m AM/PM"
    # $endDate = "5/20/2013"
    $startParseString = checkDateString $startDate
    $endParseString = checkDateString $endDate
   
    $startDate = [dateTime]::ParseExact($startDate, $startParseString, $null)
    $endDate = [dateTime]::ParseExact($endDate, $endParseString , $null)
 
 
    $userData = @{
                    "start" = $startDate;
                    "end" = $endDate;
                    "folderPath" = $folderPath;
                 }
 
    return $userData
}
#
#   Function Name:  checkUserIDString
#   
#   Inputs:
#       - $string: A string containing the user ID that is to be validated
#
#   Output:
#       - $package: A dictionary with the following entries...
#           - "isValid"     -> A boolean value indicating whether the ID entered was a valid ID
#           - "path"        -> A string that contains the original string if it is a valid ID or $null if it is not.
#           - "message"     -> A message describing the output. Error message or success message.
#
#   Purpose:    The purpose of this function is to check whether the user inputed ID value is a number of the right lenght or if it is the 
#               string 'All' which would indicate the function would be looking through all ID's
#
function checkUserIDString($string)
{
    $length = $string.length
 
    if ($string -eq "all" -or $string -eq "All")
    {
        $package = @{ "isValid" = $true;
                    "path" = "";
                    "message" = "User has chosen to search all user IDs";
                   }
        return $package
    }
 
 
    if ($length -ne 3)
    {
        
       $package = @{ "isValid" = $false;
                    "path" = $null;
                    "message" = "The user ID entered is not of the right length. Please try again.";
                   }
 
        return $package
 
    }
   
    if (!($string -match "^[0-9]*$"))
    {
    
        $package = @{ "isValid" = $false;
                    "path" = $null;
                    "message" = "The user ID entered is not a numeric value. Please try again.";
                   }
 
        return $package
    
    }
 
    $package = @{ "isValid" = $true;
                    "path" = $string;
                    "message" = "The userID entered was in the correct format.";
                   }
 
    return $package
}
function checkDateString($string)
{
    $tokens = $string.Split(" ")
 
    $count = $tokens.length
   
    if ($count -eq 1)
    {
        $parseString = "M/d/yyyy"
    }
    elseif ($count -eq 2)
    {
        $parseString = "M/d/yyyy H:m"
    }
    elseif ($count -eq 3)
    {
        $parseString = "M/d/yyyy h:m tt"
    }
 
    return $parseString
 
}
function updateFilesInRange($range)
{
    $pathToFiles = $range.folderPath
   
    $theChild = Get-ChildItem -Path $pathToFiles | Where {$_.PSIsContainer -eq $true -and $_.Name -eq "KinectData"}
 
    Get-ChildItem -Path $theChild.FullName | Where {$_.PSIsContainer -eq $true} | Foreach {
 
        $folderDate = extractDateFromFolder $_.Name
 
                if ($folderDate -ne $null)
        {
            $dateDiff = ($folderDate - $range.start)
 
            if ($dateDiff.Days -eq 0 -or ($folderDate -ge $range.start -and $folderDate -le $range.end))
            {
                Get-ChildItem $_.FullName -Recurse | Where-Object {$_.Name -like "*.avi" -and !$_.PSIsDirectory} | Foreach-Object {
              
                   $videoCreationDate = extractDate $_.Name
               
                   if($videoCreationDate -ne $null -and $videoCreationDate -ge $range.start -and $videoCreationDate -le $range.end)
                   {
                        $newVideo = [io.path]::ChangeExtension($_.FullName, '.mp4')
                                                $ArgumentList = '-i "{0}" -an -b:v 64k -bufsize 64k -vcodec libx264 -pix_fmt yuv420p "{1}"' -f $_.FullName, $newVideo;
            
                        $convertMessage = ("Converting video with argument list " + $ArgumentList)
               
                        Write-Host $convertMessage
                       
                        Start-Process -FilePath "C:\Program Files\ffmpeg\bin\ffmpeg.exe" -ArgumentList $ArgumentList -Wait -NoNewWindow;
                   }
 
               }
            }
        }
    }
 
}
function extractDateFromFolder($folderName)
{
 
    $dateTokens = $folderName -split "_"
 
                if ($dateTokens.Count -ne 3)
                {
                                return $null
                }
               
                $dateString = ($dateTokens[0] + "/" + $dateTokens[1] + "/" + $dateTokens[2])
               
                $dateObject = [dateTime]::ParseExact($dateString, "MM/dd/yyyy" , $null)
               
                # Write-Host $dateObject
 
                return $dateObject
}
function extractDate($path)
{
 
  $pathTokens = $path -split "-"
 
  $dateTokens = $pathTokens[1] -split "_"
  $timeTokens = $pathTokens[2] -split "_"
 
  $timeString = ($dateTokens[0] + "/" + $dateTokens[1] + "/" + $dateTokens[2] + " " + $timeTokens[0] + ":" + $timeTokens[1] + ":" + $timeTokens[2])
 
  $dateObject = [dateTime]::ParseExact($timeString, "MM/dd/yyyy HH:mm:ss" , $null)
 
  return $dateObject
}
 
# Main program
 
$userData = getUserData
 
Write-Host ("Start Date: " + $userData.start)
Write-Host ("End Date: " + $userData.end)
Write-Host ("Folder path: " + $userData.folderPath)
 
updateFilesInRange $userData
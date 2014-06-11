﻿#
#   Function Name: getUserData
#
#   Inputs: None
#
#   Output:
#       -$userData: A dictionary containing the entries...
#           - "start"     ->    A dateTime object that marks the start of the date range
#           - "end"       ->    A dateTime object that marks the end of the date range
#           - "folderPath"->    A path (string) object containing the folderPath to the folder containing the subfolder "KinectData"
#
#   Purpose: To gather input from the user to know which videos this script should convert
#
function getUserData
{
    Do {
        $rootPath = Read-Host "Enter the path to the folder containing the dated folders containing the video files"
		
        $pathTest = Test-Path $rootPath
 
        if (!$pathTest) { Write-Host "Path provided was not valid, try again." }
        } while ($pathTest -eq $false)
		
    $rootPathLength = $rootPath.length - 1
 
    if($rootPath[$rootPathLength] -ne "\")
    {
        $rootPath = "$rootPath\"
    }
 
    $folderPath = $rootPath
 
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
#
#	Function Name: checkDateString
#
#	Inputs: 
#		-$string: A string containing the date that whose format will be checked. 
#
#	Output:
#		-$parseString: A string that shows the format of the date string that was passed into the function. 
#
#	Purpose:	To determine the format of the date string so that the ParseExact function knows what kind of
#				date to expect.
#
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
#
#	Function Name: updateFilesInRange
#
#	Inputs:
#		-$range: A dictionary containing the following entries...
#           - "start"     ->    A dateTime object that marks the start of the date range
#           - "end"       ->    A dateTime object that marks the end of the date range
#           - "folderPath"->    A path (string) object containing the folderPath to the folder containing the subfolder "KinectData"
#	Output: None
#
#	Purpose: To convert videos within the specified date range and folder from .avi's to .mp4's 
#
function updateFilesInRange($range)
{
    $pathToFiles = $range.folderPath
   
    # $theChild = Get-ChildItem -Path $pathToFiles | Where {$_.PSIsContainer -eq $true -and $_.Name -eq "KinectData"}
 
    sortedFileConversion $pathToFiles $range
 
}
#
#	Function Name: extractDateFromFolder
#
#	Inputs:
#		-$folderName: A string containing the name of the folder
#
#	Output:
#		-$dateObject: A date object built from the date specified in the string $folderName which was passed into the function.
#
#	Purpose:	
#       To convert the folder name, which is a basic string object, into a date object which can be used for comparisons with
#		other date objects. 
#
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
function extractDateFromFolder2($folderName)
{
 
    $dateTokens = $folderName -split "_"
 
                if ($dateTokens.Count -ne 3)
                {
                                return $null
                }
               
                $dateString = ($dateTokens[0] + "/" + $dateTokens[1] + "/" + $dateTokens[2])
               
                $dateObject = [dateTime]::ParseExact($dateString, "MM/dd/yyyy" , $null)
               
                return $dateObject
}
#
#	Function Name: extractDate
#
#   Inputs:
#       -$path: A string containing the name of the file from which a date can be extracted
#
#   Output:
#       -$dateObject: A dateTime object built from the string that was passed into the function
#
#   Purpose:
#       To convert the name of a file into a date which can be used for comparisons.
#
function extractDate($path)
{
 
  $pathTokens = $path -split "-"
 
  $dateTokens = $pathTokens[1] -split "_"
  $timeTokens = $pathTokens[2] -split "_"
 
  $timeString = ($dateTokens[0] + "/" + $dateTokens[1] + "/" + $dateTokens[2] + " " + $timeTokens[0] + ":" + $timeTokens[1] + ":" + $timeTokens[2])
 
  $dateObject = [dateTime]::ParseExact($timeString, "MM/dd/yyyy HH:mm:ss" , $null)
 
  return $dateObject
}
function sortedFileConversion($path, $range)
{
	$foldersArray = @()


    Get-ChildItem -Path $path | Where-Object {$_.PSIsContainer -eq $true} | ForEach-Object {
        $fullPath = $_.FullName

        $name = $_.Name

        $date = extractDateFromFolder2 $name

        $props = @{
                   Path = $fullPath
                   Name = $name
                   Date = $date
                   }

        $theObject = New-Object PSObject -Property $props
        
        Write-Host ("The range start is " + $range.start)
        Write-Host ("The range end is " + $range.end)
        Write-Host ("The folder's date is " + $date)
        Write-Host ("The path is " + $path)

        if($date -ge $range.start -and $date -le $range.end)
        {
            $foldersArray += $theObject
        }
    }

    $foldersArray | Sort-Object {$_.Date} -Descending | ForEach-Object {
       
       Get-ChildItem -Path $_.Path -Recurse | Where-Object {$_.PSIsContainer -eq $false -and $_.Extension -eq ".avi"} | ForEach-Object {
       
        startConvertProcessOnVideo $_
        }
    }

}
function startConvertProcessOnVideo($path)
{
	$newVideo = [io.path]::ChangeExtension($path.FullName, '.mp4')
	
	$ArgumentList = '-i "{0}" -an -b:v 64k -bufsize 64k -vcodec libx264 -pix_fmt yuv420p "{1}"' -f $path.FullName, $newVideo;

	$convertMessage = ("Converting video with argument list " + $ArgumentList)

	Write-Host $convertMessage

	Start-Process -FilePath "C:\Users\arfv2b\Downloads\ffmpeg\ffmpeg-20140609-git-958168d-win64-static\bin\ffmpeg.exe" -ArgumentList $ArgumentList -Wait -NoNewWindow;
}
# Main program
 

$userData = getUserData
 
Write-Host ("Start Date: " + $userData.start)
Write-Host ("End Date: " + $userData.end)
Write-Host ("Folder path: " + $userData.folderPath)
 
updateFilesInRange $userData

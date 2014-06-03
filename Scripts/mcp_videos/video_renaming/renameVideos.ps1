﻿# Function definitions
 
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
    $pathToFiles = "\\echo\mcp\100\"
   
    $theChild = Get-ChildItem -Path $pathToFiles | Where {$_.PSIsContainer -eq $true -and $_.Name -eq "KinectData"}
 
    Get-ChildItem -Path $theChild.FullName | Where {$_.PSIsContainer -eq $true} | Foreach {
 
        $folderDate = extractDateFromFolder $_.Name
 
        if ($folderDate -ne $null)
        {
            Write-Host $folderDate
 
        }
    }
 
}
function updateFilesTest
{
 $pathToFiles = "C:\Users\arfv2b\Desktop\testingThings\"
   
   $firstRange = getRanges 1
   $secondRange = getRanges 2


   # $dateRangeOne = @{ "startDate" : [dateTime]::ParseExact("6/1/2012", "M/d, $null)
    $theChild = Get-ChildItem -Path $pathToFiles | Where {$_.PSIsContainer -eq $true -and $_.Name -eq "KinectData"}
 
    Write-Host $firstRange.fromStart
    Write-Host $firstRange.fromEnd

        
    Get-ChildItem -Path $theChild.FullName | Where {$_.PSIsContainer -eq $true} | Foreach {
 
        $folderDate = extractDateFromFolder $_.Name

        # Write-Host $folderDate

        
        if (($folderDate -ge $firstRange.fromStart -and $folderDate -le $firstRange.fromEnd) -or ($folderDate -ge $secondRange.fromStart -and $folderDate -le $secondRange.fromEnd))
        {
           
            Get-ChildItem -Path $_.FullName | Foreach {
               renameFile $_ $firstRange
            }
        }
        
    }   
}
function getRanges($rangeOption)
{
    
    $dateFormatString = "MM/dd/yyyy"

    switch ($rangeOption)
    {
        1 {
            $fromStartDateString = "06/01/2012"
            $fromEndDateString = "07/25/2012"

            $toStartDateString = "02/01/2014"
            $toEndDateString = "03/31/2014"
        }

        2 {
            $fromStartDateString = "08/11/2012"
            $fromEndDateString = "10/07/2012"

            $toStartDateString = "04/04/2014"
            $toEndDateString = "05/31/2014"
        }

        default {
            $fromStartDateString = $null
            $fromEndDateString = $null

            $toStartDateString = $null
            $toEndDateString = $null
        }
    }

    if ($fromStartDateString -ne $null)
    {
        $fromStartDate = [dateTime]::ParseExact($fromStartDateString, "MM/dd/yyyy" , $null)
        $fromEndDate = [dateTime]::ParseExact($fromEndDateString, "MM/dd/yyyy" , $null)

        $toStartDate = [dateTime]::ParseExact($toStartDateString, "MM/dd/yyyy" , $null)
        $toEndDate = [dateTime]::ParseExact($toEndDateString, "MM/dd/yyyy" , $null)


        $datesDictionary = @{
            "fromStart" = $fromStartDate;
            "fromEnd" = $fromEndDate;
            "toStart" = $toStartDate;
            "toEnd" = $toStartDate;
        }

        return $datesDictionary
    }
    else
    {
        return $null
    }
}
function renameFile($path, $rangeInfo)
{
    
    $fileType = $path.Extension

    # Write-Host ("The file is of type " + $fileType)

    $nameTokens = $path.Name -split "-"

    <##
    for( $i = 1; $i -lt $nameTokens.count; $i++)
    {
        Write-Host $nameTokens[$i]
    }
    ##>

    if ($nameTokens.count -eq 3)
    {
        $fileDate = convertToDate $nameTokens[1] 3

        $dateDifference = NEW-TIMESPAN -Start $rangeInfo.fromStart -End $fileDate

        Write-Host ("The duration was " + $dateDifference)

        Write-Host ("The date was " + $fileDate)


        $newDate = $rangeInfo.toStart

        $newDate = $newDate.AddDays($dateDifference.Days)

        Write-Host ("The new date is " $newDate)
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
function convertToDate($dateString, $option)
{
    switch ($option)
    {
        1 {
            $dateFormat = "MM/dd/yyyy"
        }

        2 {
            $dateFormat = "M/dd/yyyy"
        }

        3 {
            $dateFormat = "MM_dd_yyyy"
        }

        default {
            $dateFormat = "MM/dd/yyyy"
        }
    }

    $dateObject = [dateTime]::ParseExact($dateString, $dateFormat, $null)

    return $dateObject
}
# Main program
 
updateFilesTest

<##
$datesDictionary = getRanges 1

Write-Host ("The from start date is " + $datesDictionary.fromStart)
Write-Host ("The from end date is " + $datesDictionary.fromEnd)
Write-Host ("The to start date is " + $datesDictionary.toStart)
Write-Host ("The to end date is " + $datesDictionary.toEnd)
##>




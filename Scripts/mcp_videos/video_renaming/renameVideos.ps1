# Function definitions
 
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
function updateFilesTest($pathToUse)
{
    $pathToFiles = $pathToUse

    $firstRange = getRanges 1
    $secondRange = getRanges 2
    $thirdRange = getRanges 3

    # $dateRangeOne = @{ "startDate" : [dateTime]::ParseExact("6/1/2012", "M/d, $null)
    $theChild = Get-ChildItem -Path $pathToFiles | Where {$_.PSIsContainer -eq $true -and $_.Name -eq "KinectData"}

    Write-Host $firstRange.fromStart
    Write-Host $firstRange.fromEnd

        
    Get-ChildItem -Path $theChild.FullName | Where {$_.PSIsContainer -eq $true} | Foreach {
 
        $folderDate = extractDateFromFolder $_.Name

        # Write-Host $folderDate

        
        if ($folderDate -ge $firstRange.fromStart -and $folderDate -le $firstRange.fromEnd)
        {
           
            Get-ChildItem -Path $_.FullName | Foreach {
               renameFile $_ $firstRange
            }

            changeFolderDate $_ $folderDate $firstRange
        }
        elseif($folderDate -ge $secondRange.fromStart -and $folderDate -le $secondRange.fromEnd)
        {
            Get-ChildItem -Path $_.FullName | Foreach {
               renameFile $_ $secondRange
            }

            changeFolderDate $_ $folderDate $secondRange
        }
    }   

    Get-ChildItem -Path $theChild.FullName | Where {$_.PSIsContainer -eq $true} | Foreach {

        $folderDate = extractDateFromFolder $_.Name

        # Write-Host "Second get-child is running"
        if($folderDate -ge $thirdRange.toStart -and $folderDate -le $thirdRange.toEnd)
        {
            addFirstRange $_ $thirdRange $folderDate
        }
    }
}
function changeFolderDate($path, $folderDate, $rangeInfo)
{
    $folderDirectory = $path.DirectoryName

    $dateDifference = NEW-TIMESPAN -Start $rangeInfo.fromStart -End $folderDate

    $daysDiff = $dateDifference.Days

    $newDate = $rangeInfo.toStart

    $newDate = $newDate.AddDays($daysDiff)

    $nfDateString = convertDateToString $newDate 2

    #Write-Host ("The date to convert was " + $folderDate)
    #Write-Host $nfDateString

<##
    Write-Host ("The folder date was " + $folderDate)
    Write-Host ("The folder path was " + $path.FullName)
    Write-Host ("The new date string was " + $nfDateString)
##>
    Rename-Item $path.FullName -newName $nfDateString
}
function dateAsArray($date)
{
    $month = $date.Month
    $days = $date.Day
    $year = $date.Year

    $dateArray = @{
        "month" = $month;
        "day" = $days;
        "year" = $year;
    }

    return $dateArray
}
function convertDateToString($date, $option)
{
    switch ($option)
    {
        1 {
            $sep = "/"
        }

        2 {
           $sep = "_" 
        }

        default {
            $sep = "/"
        }
    }


    $dateArray = dateAsArray $date


    if($dateArray.month -ge 10)
    {
        $monthMod = ""
    }
    else
    {
        $monthMod = "0"
    }

    if ($dateArray.day -ge 10)
    {
        $dayMod = ""
    }
    else
    {
        $dayMod = "0"
    }


    $dateString = ($monthMod + $dateArray.month + $sep + $dayMod + $dateArray.day + $sep + $dateArray.year)

    return $dateString

}
function getRanges($rangeOption)
{
    
    $dateFormatString = "MM/dd/yyyy"

    switch ($rangeOption)
    {
        1 {
            $fromStartDateString = "06/01/2012"
            $fromEndDateString = "07/25/2012"

            $toStartDateString = "02/05/2014"
            $toEndDateString = "03/31/2014"
        }

        2 {
            $fromStartDateString = "08/11/2012"
            $fromEndDateString = "10/07/2012"

            $toStartDateString = "04/04/2014"
            $toEndDateString = "05/31/2014"
        }
        3 {
            $fromStartDateString = "02/05/2014"
            $fromEndDateString = "02/08/2014"

            $toStartDateString = "02/01/2014"
            $toEndDateString = "02/04/2014"
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

        # Write-Host ("The duration was " + $dateDifference)

        # Write-Host ("The date was " + $fileDate)


        $newDate = $rangeInfo.toStart

        $newDate = $newDate.AddDays($dateDifference.Days)

        # Write-Host ("The new date is " + $newDate)

        $dateTokens = $nameTokens[1] -split "_"

        $days = $newDate.Day
        $month = $newDate.month
        $year = $newDate.year


        if($days -ge 10)
        {
            $daysMod = ""
        }
        else
        {
            $daysMod = "0"
        }

        if($month -ge 10)
        {
            $monthMod = ""
        }
        else
        {
            $monthMod = "0"
        }

        $newDateString = ($nameTokens[0] + "-" + $monthMod + $month + "_" + $daysMod + $days + "_" + $year + "-" + $nameTokens[2])

<##
        $fullNameSplit = $_.FullName -split "\"

        $fullNameBase = ""

        for($i = 0; i -lt $fullNameSplit.count - 1 ; $i++)
        {
            $fullNameBase = ($fullNameBase + "\" + $fullNameSplit[$i])
        }
        ##>

        $directory = $_.DirectoryName

        $newDateString = ($directory + "\" + $newDateString)


        #Write-Host ("The old date string was " + $path.FullName)
        #Write-Host ("The new date string is " + $newDateString)

        Rename-Item $path.FullName $newDateString
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
function addFirstRange($path, $rangeInfo, $folderDate)
{
    Write-Host ("addFirstRange is running with $path = " + $path + " and $rangeInfo = " + $rangeInfo + " and $folderDate = " + $folderDate)

    $dateDifference = NEW-TIMESPAN -Start $rangeInfo.fromSart -End $folderDate

    $newDate = $rangeInfo.toStart

    $newDate = $newDate.AddDays($dateDifference.Days)

    $newDateString = convertDateToString $newDate 2

    $folderDirectory = $path.DirectoryName

    Copy-Item ($path + "\*") ($folderDirectory + "\" + $newDateString)
}
# Main program
 


$pathOption = Read-Host "Testing path (1) or echo path (2)"

switch ($pathOption) {
    1 {
        $path = "C:\Users\arfv2b\Desktop\testingThings\"
    }

    2 {
        $path = "\\echo\mcp\100\"
    }

    3 {
        $folderName =  Read-Host "Enter the folder number"

        $path = ("C:\Users\arfv2b\Desktop\testingThings" + $folderName + "\")
    }

    default {
         $path = "C:\Users\arfv2b\Desktop\testingThings\"   
    }
}

updateFilesTest $path

<##
$datesDictionary = getRanges 1

Write-Host ("The from start date is " + $datesDictionary.fromStart)
Write-Host ("The from end date is " + $datesDictionary.fromEnd)
Write-Host ("The to start date is " + $datesDictionary.toStart)
Write-Host ("The to end date is " + $datesDictionary.toEnd)
##>




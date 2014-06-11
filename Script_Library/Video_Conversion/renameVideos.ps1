#
# Function definitions
#

function updateFileNames($pathToUse)
{
    $pathToFiles = $pathToUse

    $firstRange = getRanges 1
    $secondRange = getRanges 2
    $thirdRange = getRanges 3

    $theChild = Get-ChildItem -Path $pathToFiles | Where {$_.PSIsContainer -eq $true -and $_.Name -eq "KinectData"}
   
    Get-ChildItem -Path $theChild.FullName | Where {$_.PSIsContainer -eq $true} | Foreach {
 
        $folderDate = extractDateFromFolder $_.Name
  
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

        if($folderDate -ge $thirdRange.fromStart -and $folderDate -le $thirdRange.fromEnd)
        {
            addFirstRange $_ $thirdRange $folderDate $pathToFiles
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

    $nameTokens = $path.Name -split "-"

    if ($nameTokens.count -eq 3)
    {
        $fileDate = convertToDate $nameTokens[1] 3

        $dateDifference = NEW-TIMESPAN -Start $rangeInfo.fromStart -End $fileDate

        $newDate = $rangeInfo.toStart

        $newDate = $newDate.AddDays($dateDifference.Days)

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

        $directory = $_.DirectoryName

        $newDateString = ($directory + "\" + $newDateString)

        Rename-Item $path.FullName $newDateString
    }
}

function addFirstRange($path, $rangeInfo, $folderDate, $pathToFiles)
{
    # Write-Host ("addFirstRange is running with $path = " + $path + " and $rangeInfo = " + $rangeInfo.fromSart + " and $folderDate = " + $folderDate)

    $rangeStart = $rangeInfo.fromStart

    $dateDifference = NEW-TIMESPAN -Start $rangeStart -End $folderDate

    $newDate = $rangeInfo.toStart

    $newDate = $newDate.AddDays($dateDifference.Days)

    $newDateString = convertDateToString $newDate 2

    $folderDirectoryTokens = $path.FullName -split "\\"

    if($folderDirectoryTokens.count -eq 7)
    {
        $folderDirectory = ""

        for ($i = 0; $i -lt ($folderDirectoryTokens.count - 1); $i++)
        {
            $folderDirectory = ($folderDirectory + $folderDirectoryTokens[$i] + "\")
        }
    }

    $cpFromPath = $path.FullName + "\*"

    $cpToPath = $folderDirectory + $newDateString
    
    #write-host $cpFromPath

    $replaceString = ($path.Name + "\*$")

    #Write-Host ("Replace string is " + $replaceString)
    #Write-Host ("New date string is " + $newDateString)

    $cpToPath = ($pathToFiles + "\KinectData\" + $newDateString)
     
    #write-host $cpToPath

    New-Item -ItemType directory -Path $cpToPath

    Copy-Item $cpFromPath $cpToPath -recurse

    Get-ChildItem -Path $cpToPath | Foreach {
               renameFile $_ $rangeInfo
            }

    # Copy-Item ($path + "\*") ($folderDirectory + "\" + $newDateString)
}

#
# Utility Functions
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

function changeFolderDate($path, $folderDate, $rangeInfo)
{
    $folderDirectory = $path.DirectoryName

    $dateDifference = NEW-TIMESPAN -Start $rangeInfo.fromStart -End $folderDate

    $daysDiff = $dateDifference.Days

    $newDate = $rangeInfo.toStart

    $newDate = $newDate.AddDays($daysDiff)

    $nfDateString = convertDateToString $newDate 2

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

#
# Main program
#

$path = Read-Host "Enter the path to the folder containing subfolder 'kinectData'"

$confirmMessage = ("Folders in path -> " + $path + " will be modified. Is this correct?")

Write-Host $confirmMessage

$userOption = Read-Host "Enter any key to continue or Ctrl-C to exit"

updateFileNames $path



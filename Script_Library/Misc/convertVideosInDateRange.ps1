# Function definitions

function getDates
{
    #Prompt the user to enter the date range

    $startDate = Read-Host "Enter the start date for the date range in the format M/d/YYYY"
    
    $endDate = Read-Host "Enter the end date for the date range in the format M/d/YYYY"

    $startDate = [dateTime]::ParseExact($startDate, "M/d/yyyy", $null)
    $endDate = [dateTime]::ParseExact($endDate, "M/d/yyyy", $null)

    $dateRange = @{"start" = $startDate;
                   "end" = $endDate;
                   }

    return $dateRange;
                    
}
function updateFilesInRange($range, $pathToFiles)
{

    # Selection all items within the $pathToFiles directory that meet the following conditions...
    # 1. It is not a directory
    # 2. It was created after the start of the date range
    # 3. It was created before the end of the date range
    Get-ChildItem -Path $pathToFiles -Recurse | Where-Object {$_.Name -like "*.avi" -and !$_.PSIsDirectory -and $_.CreationTime -gt $range.start -and $_.CreationTime -lt $range.end} | Foreach-Object{
       
        $filePath = $_.FullName
        
        Write-Host $filePath
        # Here you would use the file path along with ffmpeg to do the conversion
        
   }
}
# Main program

$pathToFolder = "$env:userprofile\Desktop\testDirectory\"

# Write-Host $pathToFolder

$dates = getDates

updateFilesInRange $dates $pathToFolder

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
    
    $pathToFiles = $range.folderPath

 
    # Selection all items within the $pathToFiles directory that meet the following conditions...
    # 1. It is not a directory
    # 2. It was created after the start of the date range
    # 3. It was created before the end of the date range
    <##
    Get-ChildItem -Path $pathToFiles | Where {$_.PSIsContainer -eq $true -and $_.Name -eq "KinectData"} | ForEach { Get-ChildItem -Path $_ -Recurse | Where-Object {$_.Name -like "*.avi" -and !$_.PSIsDirectory} | Foreach-Object{
       
       

       $videoCreationDate = extractDate $_.Name

       if($videoCreationDate -ne $null -and $videoCreationDate -ge $range.start -and $videoCreationDate -le $range.end)
       {
            # $newName = $_.Basename + ".mp4";
            #C:\Users\Bigben\Desktop\ffmpeg-20140519-git-76191c0-win64-static\bin\ffmpeg.exe "$_" -f mp4 -r 25 -s 320*240 -b 768 -ar 44000 -ab 112 $newName;
        
            # Here you would use the file path along with ffmpeg to do the conversion
            $newVideo = [io.path]::ChangeExtension($_.FullName, '.mp4')
 
            # Declare the command line arguments for ffmpeg.exe
            $ArgumentList = '-i "{0}" -an -b:v 64k -bufsize 64k -vcodec libx264 -pix_fmt yuv420p "{1}"' -f $_.FullName, $newVideo;
 
    
    
            # Display message show user the arguments list of the conversion
            $convertMessage = ("Converting video with argument list " + $ArgumentList)
    
            Write-Host $convertMessage

            # Start-Process -FilePath C:\Users\muengrcerthospkinect\Desktop\Kinect\ffmpeg.exe -ArgumentList $ArgumentList -Wait -NoNewWindow;
       }

   }}
   ##>
   Get-ChildItem -Path $pathToFiles | Where {$_.PSIsContainer -eq $true -and $_.Name -eq "KinectData"} | Foreach {




	$folderDate = extractDateFromFolder $_.Name
	
	if($folderDate -ne $null -and $folderDate -le $range.end -ge $range.start)
	{
		Get-ChildItem -Path $_FullName -Recurse | Where-Object {$_.Name -like "*.avi" -and !$_.PSIsDirectory} | ForEach-Object {
			Write-Host $_.FullName
      			 $videoCreationDate = extractDate $_.Name

		       if($videoCreationDate -ne $null -and $videoCreationDate -ge $range.start -and $videoCreationDate -le $range.end)
       			{
            			# $newName = $_.Basename + ".mp4";
            			#C:\Users\Bigben\Desktop\ffmpeg-20140519-git-76191c0-win64-static\bin\ffmpeg.exe "$_" -f mp4 -r 25 -s 320*240 -b 768 -ar 44000 -ab 112 $newName;
        			Write-Host $_.FullName
            			# Here you would use the file path along with ffmpeg to do the conversion
            			$newVideo = [io.path]::ChangeExtension($_.FullName, '.mp4')
 
 			           # Declare the command line arguments for ffmpeg.exe
            			$ArgumentList = '-i "{0}" -an -b:v 64k -bufsize 64k -vcodec libx264 -pix_fmt yuv420p "{1}"' -f $_.FullName, $newVideo;
 
    
    
 			           # Display message show user the arguments list of the conversion
            			$convertMessage = ("Converting video with argument list " + $ArgumentList)
    
    			        Write-Host $convertMessage

		            # Start-Process -FilePath C:\Users\muengrcerthospkinect\Desktop\Kinect\ffmpeg.exe -ArgumentList $ArgumentList -Wait -NoNewWindow;
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
	
	$dateObject = [dateTime]::ParseExact($timeString, "MM/dd/yyyy" , $null)
	
	Write-Host $dateObject

	return $dateObject
}
function extractDate($path)
{

  $pathTokens = $path -split "-"

  $dateTokens = $pathTokens[1] -split "_"
  $timeTokens = $pathTokens[2] -split "_"

  $timeString = ($dateTokens[0] + "/" + $dateTokens[1] + "/" + $dateTokens[2] + " " + $timeTokens[0] + ":" + $timeTokens[1] + ":" + $timeTokens[2])

  $dateObject = [dateTime]::ParseExact($timeString, "MM/dd/yyyy HH:mm:ss" , $null)

  # Write-Host $timeString

  return $dateObject
} 
function targetTesting
{
    $folderPath = "D:\mcp\"
    $userID = "100"
    $startDate = [dateTime]::ParseExact("07/01/2013", "MM/dd/yyyy" , $null)
    $endDate = [dateTime]::ParseExact("10/31/2013", "MM/dd/yyyy" , $null)

    
    Write-Host("The path to folder is " + $folderPath)
    Write-Host ("The user ID is " + $userID)
    Write-Host("The start date is " + $startDate)
    Write-Host("The end date is " + $endDate)

    $pathToFiles = ($folderPath + $userID)

    $theChild = Get-ChildItem -Path $pathToFiles | Where {$_.PSIsContainer -eq $true -and $_.Name -eq "KinectData"}

    Write-Host $theChild.FullName

    Get-ChildItem -Path $theChild.FullName | Where {$_.PSIsContainer -eq $true} | Foreach {
        Write-Host $_.FullName
    }

    # Selection all items within the $pathToFiles directory that meet the following conditions...
    # 1. It is not a directory
    # 2. It was created after the start of the date range
    # 3. It was created before the end of the date range
    <##
    Get-ChildItem -Path $pathToFiles | Where {$_.PSIsContainer -eq $true -and $_.Name -eq "KinectData"} | ForEach { Get-ChildItem -Path $_ -Recurse | Where-Object {$_.Name -like "*.avi" -and !$_.PSIsDirectory} | Foreach-Object{
       
       

       $videoCreationDate = extractDate $_.Name

       if($videoCreationDate -ne $null -and $videoCreationDate -ge $range.start -and $videoCreationDate -le $range.end)
       {
            # $newName = $_.Basename + ".mp4";
            #C:\Users\Bigben\Desktop\ffmpeg-20140519-git-76191c0-win64-static\bin\ffmpeg.exe "$_" -f mp4 -r 25 -s 320*240 -b 768 -ar 44000 -ab 112 $newName;
        
            # Here you would use the file path along with ffmpeg to do the conversion
            $newVideo = [io.path]::ChangeExtension($_.FullName, '.mp4')
 
            # Declare the command line arguments for ffmpeg.exe
            $ArgumentList = '-i "{0}" -an -b:v 64k -bufsize 64k -vcodec libx264 -pix_fmt yuv420p "{1}"' -f $_.FullName, $newVideo;
 
    
    
            # Display message show user the arguments list of the conversion
            $convertMessage = ("Converting video with argument list " + $ArgumentList)
    
            Write-Host $convertMessage

            # Start-Process -FilePath C:\Users\muengrcerthospkinect\Desktop\Kinect\ffmpeg.exe -ArgumentList $ArgumentList -Wait -NoNewWindow;
       }

   }}
   
   Get-ChildItem -Path $pathToFiles | Where {$_.PSIsContainer -eq $true -and $_.Name -eq "KinectData"} | Foreach {




    $folderDate = extractDateFromFolder $_.Name
    
    if($folderDate -ne $null -and $folderDate -le $range.end -ge $range.start)
    {
        Get-ChildItem -Path $_FullName -Recurse | Where-Object {$_.Name -like "*.avi" -and !$_.PSIsDirectory} | ForEach-Object {
            Write-Host $_.FullName
                 $videoCreationDate = extractDate $_.Name

               if($videoCreationDate -ne $null -and $videoCreationDate -ge $range.start -and $videoCreationDate -le $range.end)
                {
                        # $newName = $_.Basename + ".mp4";
                        #C:\Users\Bigben\Desktop\ffmpeg-20140519-git-76191c0-win64-static\bin\ffmpeg.exe "$_" -f mp4 -r 25 -s 320*240 -b 768 -ar 44000 -ab 112 $newName;
                    Write-Host $_.FullName
                        # Here you would use the file path along with ffmpeg to do the conversion
                        $newVideo = [io.path]::ChangeExtension($_.FullName, '.mp4')
 
                       # Declare the command line arguments for ffmpeg.exe
                        $ArgumentList = '-i "{0}" -an -b:v 64k -bufsize 64k -vcodec libx264 -pix_fmt yuv420p "{1}"' -f $_.FullName, $newVideo;
 
    
    
                       # Display message show user the arguments list of the conversion
                        $convertMessage = ("Converting video with argument list " + $ArgumentList)
    
                        Write-Host $convertMessage

                    # Start-Process -FilePath C:\Users\muengrcerthospkinect\Desktop\Kinect\ffmpeg.exe -ArgumentList $ArgumentList -Wait -NoNewWindow;
                }
        }
    }
   }
   ##>
}
 
 
# Main program

# $userData = getUserData
 
<## 
Write-Host ("Start Date: " + $userData.start)
Write-Host ("End Date: " + $userData.end)
Write-Host ("Folder path: " + $userData.folderPath)
##>

# updateFilesInRange $userData 

targetTesting
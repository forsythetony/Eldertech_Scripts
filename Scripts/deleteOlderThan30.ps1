$kinectPath = "C:\Users\Joyce\Desktop\testFiles"
$logFileName = "deletionLog.txt"

$dateThreshold = 1

# Check to see if there is a deletionLogger text file, if not create one
    
    $logFilePath = checkLoggerFile $kinectPath $logFileName
    
    Write-Host "This is the logFilePath: " + ($logFilePath)
    
    DeleteFiles $dateThreshold $kinectPath $logFilePath





function DeleteFiles ([int]$daysAgo, $path, $logFilePath)
{
	$limit = (Get-Date).AddSeconds(-$daysAgo)
    
     
    Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and  $_.CreationTime -lt $limit } | Foreach-Object{
        
	    
		
      
        
        $cmpStr = $_.FullName
        
        if(($logFilePath.CompareTo($cmpStr)))
        {
            logDeletion $logFilePath "file" $_
            Remove-Item $_.FullName
        }
        else
        {
            Write-Host "It was True!"
        }
   }
    
}
function checkLoggerFile ($path, $nameOfLoggerFile)
{
    $filePath = $path + "\" + $nameOfLoggerFile
    
    if (!(Test-Path $filePath))
    {
        New-Item $filePath -type file
    }
    
    return $filePath
}
function logDeletion($logPath, $type, $file)
{
	$currentDate = (Get-Date).ToString()
	
	$logString = "The " + ($type) + " " + ($file.FullName) + " was deleted on " + ($currentDate)
	
	Add-Content $logPath $logString
}
# Variables to set

$kinectPath = "C:\Users\Joyce\Desktop\testFiles"
$logFileName = "deletionLog.txt"
$dateThreshold = 30


# Check to see if there is a log file, if there is not one then create a file and saved the path to it
$logFilePath = checkLoggerFile $kinectPath $logFileName
    
# Delete files that were created more than $dateThreshold days ago and log results in the log file
DeleteFiles $dateThreshold $kinectPath $logFilePath

# Delete directories that were created more than $dateThreshold days ago and log results in the log file
DeleteDirectories $dateThreshold $kinectPath $logFilePath


function DeleteDirectories ([int]$daysAgo, $path, $logFilePath)
{
    $limit = (Get-Date).AddDays(-$daysAgo)
    
    $EmptyFolders = Get-ChildItem -Path $path | Where-Object {$_.PSIsContainer -eq $true -and (Get-ChildItem -Path $_.FullName -Recurse) -eq $null -and $_.CreationTime -lt $limit} | Foreach-Object{
       
        $cmpStr = $_.FullName
        
        if(($logFilePath.CompareTo($cmpStr)))
        {
            logDeletion $logFilePath "directory" $_
            Remove-Item $_.FullName
        }
        
   } 
    
}
   
function DeleteFiles ([int]$daysAgo, $path, $logFilePath)
{
	$limit = (Get-Date).AddDays(-$daysAgo)
    
     
    Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and  $_.CreationTime -lt $limit } | Foreach-Object{
       
        $cmpStr = $_.FullName
        
        if(($logFilePath.CompareTo($cmpStr)))
        {
            logDeletion $logFilePath "file" $_
            Remove-Item $_.FullName
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
$kinectPath = "C:\Users\Joyce\Desktop\testFiles"
$dateThreshold = 1

DeleteFiles 14 "y" $kinectPath





function DeleteFiles ([int]$daysAgo, [string]$logging, $path)
{
	$limit = (Get-Date).AddSeconds(-$daysAgo)
    
    
    Write-Host $limit
   
    # Create log file if not already created
    
     $filePath = $path + "\loggedResults.txt"
     
     if(!(Test-Path $filePath))
     {
        New-Item  $filePath -type file
     }
   
   
        Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer } | Foreach-Object{
        
       
        Write-Host $_.FullName
        Write-Host $filePath
        
        if ($_.CreationTime -lt $limit -and $_.FullName -ne $filePath)
        {
            $currentDate = (Get-Date).ToString()
            
            $loggedString = ($_.FullName) + " is being deleted on " + $currentDate
            
            Add-Content $filePath $loggedString
            
            Remove-Item $_.FullName
        }
        
    
    }
    
}
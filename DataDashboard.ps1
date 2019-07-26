function refreshData($dbname, $serverName, $instanceName, $user, $password) {
    #run stored procedure that gathers all of the statistics
    Invoke-Sqlcmd -Query "exec $dbname.[dbo].[Gathermetrics]" -ServerInstance "$serverName\$instanceName" -Username $user -Password $password
    #get the latest value for the memory usage and print the value to the shell
    $memoryResults=Invoke-Sqlcmd -Query "select top 1 Value, Violation from $dbname.dbo.Metrics_Repo where Metric = 'Memory' order by Date desc" -ServerInstance "$serverName\$instanceName" -Username $user -Password $password
    echo "----------------`n| Memory in MB |`n----------------"
    echo $memoryResults[0]
    #if the violation detection bit is set to true, create a popup on the screen to alert the user
    if ($memoryResults[1] -eq 1) {
        $shell = New-Object -ComObject Wscript.Shell
        $out = $shell.Popup("Memory Consumption High")
        }
    #get the latest value for the number of locks on the database
    $lockResults=Invoke-Sqlcmd -Query "select top 1 Value, Violation from $dbname.dbo.Metrics_Repo where Metric = 'Locks' order by Date desc" -ServerInstance "$serverName\$instanceName" -Username $user -Password $password
    echo "`n---------`n| Locks |`n---------"
    echo $lockResults[0]
    #if the violation detection bit is set to true, create a popup on the screen to alert the user
    if ($lockResults[1] -eq 1) {
        $shell = New-Object -ComObject Wscript.Shell
        $out = $shell.Popup("Excessive Locking")
        }
    #get the latest value for the number of batches per second
    $batchResults=Invoke-Sqlcmd -Query "select top 1 Value, Violation from $dbname.dbo.Metrics_Repo where Metric = 'BatchesPerSec' order by Date desc" -ServerInstance "$serverName\$instanceName" -Username $user -Password $password
    echo "`n----------------------`n| Batches Per Second |`n----------------------"
    echo $batchResults[0]
    #if the violation detection bit is set to true, create a popup on the screen to alert the user
    if ($batchResults[1] -eq 1) {
        $shell = New-Object -ComObject Wscript.Shell
        $out = $shell.Popup("Excessive Batches")
        }
}
#prompt the user for information about the database they are connecting to and querying
$dbInput = Read-Host -Prompt "Database Name: "
$serverInput = Read-Host -Prompt "Server Name: "
$instanceInput = Read-Host -Prompt "Instance Name: "
$userInput = Read-Host -Prompt "Username: "
#hide the password from the console
$passwordInput = Read-Host -Prompt "Password: " -asSecureString         
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordInput)            
$passwordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
#continue to run the command, refreshing the data and alerting the user, sleeping for 10 seconds, and then refreshing
while (1 -eq 1) {
    clear
    refreshData -dbname $dbInput -servername $serverInput -instanceName $instanceInput -user $userInput -password $passwordPlain
    Start-Sleep -Seconds 10
    }

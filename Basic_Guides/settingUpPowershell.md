### Instructions

1. Run Powershell as administrator
2. Check the execution policy by running the command `Get-ExecutionPolicy`
3. If the output is any of the following you're all set to run scripts, if not refer to step 4.
   * AllSigned
   * RemoteSigned
   * Unrestricted
   * Bypass
4. Change the execution policy to RemoteSigned by running the following command `Set-ExecutionPolicy RemoteSigned`
5. Check the execution policy again to confirm it has changed and if so you can go run some scripts.

### Helpful Links
##### [Running Windows Powershell Scripts](http://technet.microsoft.com/en-us/library/ee176949.aspx)

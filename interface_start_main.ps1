<# Local includes #>
. "$PSScriptRoot\interface_lib_ini.ps1"
. "$PSScriptRoot\interface_lib_params.ps1"
. "$PSScriptRoot\interface_lib_sql.ps1"
. "$PSScriptRoot\interface_lib_files.ps1"
. "$PSScriptRoot\interface_lib_log.ps1"


<# Init. #>
$ErrorActionpreference = "Continue"


<# Get Parameters from interface.ini and Aquarius.ini #>
try 
{	
	$dbserver, $database, $user, $password, $event, $output_csv, $output_json, $sftp_server, $sftp_user, $sftp_password, $sftp_remotepath = Interface_Get_Params
}
catch
{ 
	Write-Error "Error at reading interface.ini or aquarius.ini"
	Write-Error $_.Exception.Message -ErrorAction Stop
}


<# Output of used configuration #>
Interface_Log_Params $dbserver $database $user $password $event $output_csv $output_json $sftp_server $sftp_user $sftp_remotepath


<# Initialize local CSV output file #>
try 
{	
	Initialize_Output_File $output_csv
}
catch
{
	Write-Error "Error at initializing of CSV output file"
	Write-Error $_.Exception.Message -ErrorAction Stop
}


<# Initialize local JSON output file #>
try 
{	
	Initialize_Output_File $output_json
}
catch
{
	Write-Error "Error at initializing of JSON output file"
	Write-Error $_.Exception.Message -ErrorAction Stop
}


<# Run Aquarius DB SQL Query #>
try 
{	
	$rows = Aquarius_Run_SQL $dbserver $database $user $password $event $output_csv
}
catch
{
	Write-Error "Error at SQL server connection or SQL execution"
	Write-Error $_.Exception.Message -ErrorAction Stop
}


<# Output of selected columns #>
Interface_Log_Rows $rows


<# Convert CSV file to JSON file #>
try 
{	
	import-csv $output_csv | ConvertTo-Json | Add-Content -Path $output_json 
}
catch
{
	Write-Error "Error converting CSV file to JSON file"
	Write-Error $_.Exception.Message -ErrorAction Stop
}


<# Transfer file using Powershell Remote #>
<#try
{
	$webserver = New-PSSession -HostName $remotehost_ip -Port $remotehost_port -UserName $remotehost_user -KeyFilePath $remotehost_privatekey
	Copy-Item $output_csv $remotehost_path -ToSession $webserver
	Copy-Item $output_json $remotehost_path -ToSession $webserver
	Remove-PSSession $webserver	
}
catch 
{ 
	Write-Error "Error publishing file to remote server"
	Write-Error $_.Exception.Message -ErrorAction Stop
}#>


<# Transfer file using SFTP #>
Interface_Log_SFTP
pscp.exe -sftp -C -pw $sftp_password $output_json $sftp_user@$sftp_server`:$sftp_remotepath
if ($LASTEXITCODE -ne 0) {
    Write-Error "Error transferring file via SFTP using PSCP"
    Write-Error "PSCP exit code: $LASTEXITCODE" -ErrorAction Stop
}


<# Done! #> 
$LastDateTime = Get-Date
Write-Host "`nTransfer completed at   :" $LastDateTime -ForegroundColor Yellow
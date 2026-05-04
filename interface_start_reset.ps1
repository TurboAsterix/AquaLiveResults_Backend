<# Local includes #>
. "$PSScriptRoot\interface_lib_ini.ps1"
. "$PSScriptRoot\interface_lib_params.ps1"
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


<# Set Reset File names #>
$output_csv  = $output_csv.Replace("\data\","\data_reset\")
$output_json = $output_json.Replace("\data\","\data_reset\")


<# Output of used configuration #>
Interface_Log_Params $dbserver $database $user $password $event $output_csv $output_json $sftp_server $sftp_user $sftp_remotepath


<# Transfer file using SFTP #>
Interface_Log_SFTP
pscp -sftp -batch -C -pw $sftp_password $output_json $sftp_user@$sftp_server`:$sftp_remotepath
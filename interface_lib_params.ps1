function Interface_Get_Params {

	<# Read Aquarius-Web-Interface .ini file to get Aquarius Main .ini file #>
	$interface_ini = Get-IniFile .\interface.ini

	<# Read Aquarius Main .ini file #>
	$aquarius_ini = Get-IniFile $interface_ini.aquarius_main.aquarius_ini

	<# Get Aquarius DB Connection properties #>
	$dbserver   = $aquarius_ini.DBConnection.Server
	$database   = $aquarius_ini.DBConnection.Database
	$user       = $aquarius_ini.DBConnection.User
	$event      = $aquarius_ini.Event.Last

	<# Get Interface output files #>
	$output_csv = $interface_ini.interface.output_csv
	$output_json = $interface_ini.interface.output_json

	<# Get DB password #>
	$password   = $interface_ini.dbconnection.password

	<# Get Remote Host Settings #>
	$sftp_server           = $interface_ini.server.sftp_server
	$sftp_user             = $interface_ini.server.sftp_user
	$sftp_password         = $interface_ini.server.sftp_password
	$sftp_remotepath       = $interface_ini.server.sftp_remotepath

	return $dbserver, $database, $user, $password, $event, $output_csv, $output_json, $sftp_server, $sftp_user, $sftp_password, $sftp_remotepath

}
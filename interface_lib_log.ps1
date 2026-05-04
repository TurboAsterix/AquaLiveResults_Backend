function Interface_Log_Params {
    param(
        [string] $dbserver,
        [string] $database,
        [string] $user, 
        [string] $password,
        [string] $event,
        [string] $output_csv,
        [string] $output_json,
        [string] $sftp_server,
        [string] $sftp_user,		
        [string] $sftp_remotepath 
    )

    Write-Output "The following parameters are used:"
    Write-Output "------------------------------------------------------------"
    Write-Output "SQL Database Server     : $dbserver"
    Write-Output "SQL Database            : $database"
    Write-Output "SQL Database User       : $user"
    Write-Output "Aquarius Event ID       : $event"
    Write-Output "Output file CSV         : $output_csv"
    Write-Output "Output file JSON        : $output_json"
    Write-Output "`n"
    Write-Output "SFTP Server             : $sftp_server"
    Write-Output "SFTP User               : $sftp_user" 
    Write-Output "SFTP Remote Path        : $sftp_remotepath" 	

}

function Interface_Log_Rows {
    param(
        $rows
    )

    Write-Output "`n`nAquarius SQL Query Result:"
    Write-Output "------------------------------------------------------------"
    Write-Output "CSV Exported Rows       : $rows"
}

function Interface_Log_SFTP {
    
	Write-Output "`n`nStarting SFTP Transfer:"
    Write-Output "------------------------------------------------------------"

}
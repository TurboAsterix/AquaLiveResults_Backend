function Aquarius_Run_SQL {
    param(
        [string] $dbserver,
        [string] $database,
        [string] $user, 
        [string] $password,
        [string] $event,
		[string] $output_csv		
    )

    $SQlQuery = Get-Content ".\aquarius_db_select.sql"
   
    $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
    $SqlConnection.ConnectionString = "Server = $dbserver; Database = $database; Integrated Security = False; User ID = $user; Password = $password"

    $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
    $SqlCmd.CommandText = $SqlQuery
    $SqlCmd.Connection = $SqlConnection
    [void] $SqlCmd.Parameters.AddWithValue('@Event_ID',$event)

    $SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
    $SqlAdapter.SelectCommand = $SqlCmd

    $DataSet = New-Object System.Data.DataSet

    $rows = $SqlAdapter.Fill($DataSet)

    $DataSet.Tables[0] | Export-Csv $output_csv

    return $rows
}
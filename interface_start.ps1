$i = 1
$t = 1
$sleepseconds = 0.5
$interfaceseconds = 180
$delaymod = $interfaceseconds / $sleepseconds
$LastDateTime = Get-Date

while ($true)
{ 
	if ($i % $delaymod -eq 0 -Or $i -eq 1)
	{
		Clear-Host
		$LastDateTime = Get-Date
		write-host "AquaLiveResults - Run No.: $t - Last executed:" $LastDateTime -ForegroundColor Yellow
		write-host "To Exit: E(xit) or CTRL-C`n" -ForegroundColor Yellow
		& "$PSScriptRoot\interface_start_main.ps1"
		$t++
	}

	if ($Host.UI.RawUI.KeyAvailable -and ($Host.UI.RawUI.ReadKey("IncludeKeyUp,NoEcho").Character -eq "e" )) {
        Write-Host "`nExiting now ..." -Background DarkRed
		Write-Host "`n"
		break;
    }

	Start-Sleep -Seconds $sleepseconds
	$i++	
} 
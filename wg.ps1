# For pop-up message box UI https://michlstechblog.info/blog/powershell-show-a-messagebox/ load assembly.

[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# Assign the status of the WireGuard network interface and suppress errors stemming
# from the interface being down/not existing.
$status = Get-NetAdapter wg0 -EA SilentlyContinue | Select Status

# It is easier to run a command which contains spaces in the path by creating an object for the parts.
$wireguard = 'C:\Program Files\WireGuard\wireguard.exe'
$connect = '/installtunnelservice C:\Wireguard\wg0.conf'
$disconnect = '/uninstalltunnelservice wg0'

# If $status is successfully assigned, the interface is up.
# Inform the user and offer the chance to disconnect.
if ('@{status=up}' -eq $status) {
	$oReturn = [System.Windows.Forms.MessageBox]::Show("The VPN service is currently RUNNING!`n`nWould you like to stop/disconnect the service?","VPN Status",[System.Windows.Forms.MessageBoxButtons]::YesNo)
	Switch ($oReturn) {
		"Yes" {
			Start-Process -Verb runAs $wireguard $disconnect
		}
		"No" {
			Exit
		}
		default {
			Exit
		}
	}
}
# If $status is not assigned, the interface is down.
# Inform the user and offer the chance to connect.
else {
	$oReturn = [System.Windows.Forms.Messagebox]::Show("The VPN service is currently STOPPED!`n`nWould you like to start/connect the service?","VPN Status",[System.Windows.Forms.MessageBoxButtons]::YesNo)
	Switch ($oReturn) {
		"Yes" {
			Start-Process -Verb runAs $wireguard $connect
		}
		"No" {
			Exit
		}
		default {
			Exit
		}
	}
}

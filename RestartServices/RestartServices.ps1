cls
$serversname = @('your.server1.IP', 'your.server2.IP')
$username = 'root'
$password = 'YourRootPassword'
$plinkpath = 'C:\Distr\PuTTY\'
foreach ($servername in $serversname){
    $commandRestartSSSD = 'systemctl restart sssd'
    #$commandRestartXRDP = 'systemctl restart xrdp'
    #$commandRestartZabbix = 'systemctl restart zabbix-agent'
    $commandoutput = echo y | &($plinkpath + "plink.exe") -pw $password $username@$servername $commandRestartSSSD
    #$commandoutput = echo y | &($plinkpath + "plink.exe") -pw $password $username@$servername $commandRestartXRDP
    #$commandoutput = echo y | &($plinkpath + "plink.exe") -pw $password $username@$servername $commandRestartZabbix
    Write-Host "Перезапущен sssd на сервере " $servername
    Write-Host "==============================="
}
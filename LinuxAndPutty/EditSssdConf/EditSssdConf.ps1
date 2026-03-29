cls
$serversname = @('your.server1.IP', 'your.server2.IP')
$username = 'root'
$password = 'YourRootPassword'
$plinkpath = 'C:\Distr\PuTTY\'
$users = @('user1', 'user2', 'user3', 'user4')
if(Test-Path -Path "$PSScriptRoot\sssd.conf"){Remove-Item -Path "$PSScriptRoot\sssd.conf"}
foreach ($servername in $serversname){
    Write-Host "Сервер: " $servername
    C:\Distr\PuTTY\pscp.exe -pw $password $username@$($servername):/etc/sssd/sssd.conf $PSScriptRoot #-Force
    $txt = Get-Content -Path $PSScriptRoot\sssd.conf
    Remove-Item -Path "$PSScriptRoot\sssd.conf"
    foreach ($line in $txt){
        if ($line.contains("simple_allow_users =")){
            #Write-Host "Линия simple_allow_users нашлась"
            $lineFIO = $line.Substring($line.LastIndexOf("=")+2)
            Write-Host "Строчка " $lineFIO " найдена"
            $newline = $line
            foreach ($user in $users){
                Write-Host "Пользователь: " $user
                if (-not $lineFIO.Contains($user)){
                    $newline = $newline + ", " + $user
                    Write-Host "Новая сторока: " $newline
                }
            }
            $line = $newline
        }
        Add-content "$PSScriptRoot\sssd.conf" -value $line
        #$commandRestartSSSD = 'systemctl restart sssd'
        #$commandoutput = echo y | &($plinkpath + "plink.exe") -pw $password root@$servername $commandRestartSSSD
    }
    pscp.exe -pw $password C:\PoSHScripts\Putty\sssd.conf root@$($servername):/etc/sssd
    #$commandRestartSSSD = 'systemctl restart sssd'
    #$commandoutput = echo y | &($plinkpath + "plink.exe") -pw $password $username@$servername $commandRestartSSSD
    Write-Host "==========================================="
}
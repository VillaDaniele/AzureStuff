<#
Aim of this script is to get info about Azure Application Gateway Listeners certificates, and to list their expiration dates.
The script is using an imported module: https://www.powershellgallery.com/packages/AzAppGWCert/2.0.0
#>

Set-AzContext -Subscription "4bbbef12-59e9-4fe1-9f22-79093ece9ecf"
$PumaAppGWList = 'GLOBAL_Boomi_AppGW10','GLOBAL_Boomi_AppGW40'                                  #List of current Azure Application Gatways
$AppGWCerts = @()
foreach ($PumaAppGW in $PumaAppGWList) {                                                        #Run through all Application Gateways
    try {
        $GetAppGWInfo = Get-AzAppGWCert -RG GLOBAL_Boomi_Hub1 -AppGWName $PumaAppGW             #Use imported module to fetch certicates data
        foreach ($AppGW in $GetAppGWInfo) {                                                     #Run through all certificates info
            $AppGWInfo = [PSCustomObject]@{
                'Gateway Name' = $AppGW.AppGWName
                'Listener Name' = $AppGW.ListnerName
                'Expiration Date' = $AppGW.NotAfter
            }
        $AppGWCerts += $AppGWInfo
        } 
    }
    catch {
        Write-Output $error[0]
    }
}

$AppGWCerts
#$context = New-AzStorageContext -StorageAccountName villatestsa -StorageAccountKey "9IqA7zObRCIcU/xB6Mj4LxBmv8Uz8itjorP/hRWgvULSvdqYP7NyvQ7Qk4/ijaEgaVOgwjEUSqLm+AStHFSbEw=="
#Write-Output $AppGWCerts | Export-Csv -Path "./AutomationFile.csv" -NoTypeInformation
#Set-AzStorageBlobContent -Force -Context $context -Container appgwcertexport -File "./AutomationFile.csv" -Blob "PumaAppGWCerts.csv"
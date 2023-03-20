<#
Aim of this script is to get info about Azure Application Gateway Listeners certificates, and to list their expiration dates.
The script is using an imported module: https://www.powershellgallery.com/packages/AzAppGWCert/2.0.0
#>

Set-AzContext -Subscription #SubscritpionID
$AppGWList = #AppGWList                                  #List of current Azure Application Gatways
$AppGWCerts = @()
foreach ($AppGW in $AppGWList) {                                                        #Run through all Application Gateways
    try {
        $GetAppGWInfo = Get-AzAppGWCert -RG #ResourceGroupName -AppGWName $AppGW             #Use imported module to fetch certicates data
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
#$context = New-AzStorageContext -StorageAccountName #StorageAccountName -StorageAccountKey #StorageAccountAccessKey
#Write-Output $AppGWCerts | Export-Csv -Path "./AutomationFile.csv" -NoTypeInformation
#Set-AzStorageBlobContent -Force -Context $context -Container #StorageAccountBlobContainerName -File "./AutomationFile.csv" -Blob "PumaAppGWCerts.csv"

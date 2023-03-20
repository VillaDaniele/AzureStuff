<#
Aim is to extract all Windows Azure VM and then extract their AzureAD DeviceTrustType to check which VM is Hybrid join or AAD only.

Legend for Domain Type value:
AzureAD = Device is AAD only
ServerAD = Device is Hybrid join
Empty value = Device not existing in Azure AD
"System.Object[]" value = Device might have multiple AAD entries

#>


############ FIXED VARIABLES ###############
$StAccName = #StorageAccountName
$SAAccessKey = #StorageAccountAccessKey
$SAContainerName = #StorageAccountBlobContainerName
############################################

$Subscriptions = Get-AzSubscription
$VMList = @()
foreach ($Sub in $Subscriptions) {
    Write-Host "Processing Subscription:" $Sub.Name -BackgroundColor Yellow
    try {
        Select-AzSubscription -Subscription $Sub.SubscriptionId -ErrorAction Continue
        $AzureVM = Get-AzVM | Where-Object {$_.StorageProfile.OsDisk.OsType -EQ "Windows"}
        foreach ($VM in $AzureVM) {
            $AzureADDevice = Get-AzureADDevice -Filter "DisplayName eq '$($VM.Name)'" | Select-Object DeviceTrustType
            $VMInfo = [PSCustomObject]@{
                'Subscription Name' = $Sub.Name
                'VM Name' = $VM.Name
                'Domain Type' = $AzureADDevice.DeviceTrustType
            }
            $VMList += $VMInfo
        }
    }
    catch {
        Write-Output $error[0]
    }
}
$VMList
$Context = New-AzStorageContext -StorageAccountName $StAccName -StorageAccountKey $SAAccessKey
Write-Output $VMList | Export-Csv "./AutomationFile.csv" -NoTypeInformation
Set-AzStorageBlobContent -Force -Context $Context -Container $SAContainerName -File "./AutomationFile.csv" -Blob "azureadvmlist.csv"

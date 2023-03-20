<#
Scripts to extract Azure Virtual Desktop Session Hosts information. Scope is Personal Host Pools, located in West Europe.
Information fetched is:
Host name, Assigned User, Agent Version, Last Heartbeat. 
#>

####################################
#Fixed Variables
$AVDSubID = #SubscriptionID
$AVDPersRG = #ResourceGroupName
#$StAccName = #StorageAccountName
#$SAAccessKey = #StorageAccountAccessKey
#$SAContainerName = #StorageAccountBlobContainerName
####################################

Set-AzContext -Subscription $AVDSubID                                                                                                                                           #Set Context to EA Azure AVD PROD subscription
$AVDPersHP = Get-AzWvdHostpool -ResourceGroupName $AVDPersRG | Where-Object Location -eq "westeurope"                                                                           #Get all Host Pools contained in Resource Group GLOBA_AVDPERSONAL and hosted in West Europe
$AVDHosts = @()
foreach ($HostPool in $AVDPersHP) {                                                                                                                                             #Loop to run through every Host Pool from previous Get (Line 17)
    try {
        $AVDHostsInfo = Get-AzWvdSessionHost -HostPoolName $HostPool.Name -ResourceGroupName $AVDPersRG | Select-Object Name,AssignedUser,LastHeartBeat,AgentVersion            #Get Session Host information and select Name, Assigned User, Last Heartbeat, and Agent Version
        $AVDHosts += $AVDHostsInfo
    }
    catch {
        Write-Output $error[0]
    }
}

$AVDHosts
#$Context = New-AzStorageContext -StorageAccountName $StAccName -StorageAccountKey $SAAccessKey                                                                                  #Set Context to defined Azure Storage Account
Write-Output $AVDHosts | Export-Csv -Path "./AutomationFile.csv" -NoTypeInformation                                                                                             #Export output to CSV file
#Set-AzStorageBlobContent -Force -Context $Context -Container $SAContainerName -File "./AutomationFile.csv" -Blob "AVDHostsInfo.csv"                                             #Send CSV file to Blob container in Azure Storage Account

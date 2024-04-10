$SAContainerName = "azure-vmname"
$SAName = "villatestsa"
$SAKey = "9IqA7zObRCIcU/xB6Mj4LxBmv8Uz8itjorP/hRWgvULSvdqYP7NyvQ7Qk4/ijaEgaVOgwjEUSqLm+AStHFSbEw=="

$CurrentAzureVMNames = Import-Csv -Path "/home/runner/work/AzureStuff/AzureStuff/csv/azurevmnames.csv"
$LatestAzureVMName = Import-Csv -Path "/home/runner/work/AzureStuff/AzureStuff/csv/azurevmnames.csv" | Select-Object -Last 1
$LatestAzureVMName = $LatestAzureVMName | foreach {$_.VMNAME}
$NextAvailableVMName = [int16]$LatestAzureVMName.Substring($LatestAzureVMName.Length - 3)

$NextVMName = $LatestAzureVMName.Substring(0,5) + ($NextAvailableVMName + 1)

if ($NextVMName -in $CurrentAzureVMNames.VMNAME) {
    Write-Host "The operation failed." -BackgroundColor DarkRed
}
else {
    Write-Host "The next available name for a Virtual Machine is:" $NextVMName -BackgroundColor Gray
    New-Object -TypeName PSCustomObject -Property @{
    'VMNAME' = $NextVMName
    } | Export-Csv -Path "/home/runner/work/AzureStuff/AzureStuff/csv/azurevmnames.csv" -NoTypeInformation -Append
}

$context = New-AzStorageContext -StorageAccountName $SAName -StorageAccountKey $SAKey
Set-AzStorageBlobContent -Force -Context $context -Container $SAContainerName -File "./azurevmnames.csv" -Blob "azurevmnames.csv"

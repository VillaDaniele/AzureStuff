<#
Script extract number of connected devices to Vnets.
Output is: Subscription name, Vnet name, Vnet location, DNS Servers, Count of connected devices.
#>

$PumaSubscription = Get-AzSubscription
$PumaVNET = @()
foreach ($SUB in $PumaSubscription) {
    try {
        Select-AzSubscription -SubscriptionId $Sub.SubscriptionId -ErrorAction Continue
        $AzureVNET = Get-AzVirtualNetwork
        foreach ($VNET in $AzureVNET) {
            $PREFIXEs = ($VNET).AddressSpace.AddressPrefixes
            foreach ($Prefix in $PREFIXEs) {
                $VNETInfo = [PSCustomObject]@{
                    'Subscription Name' = $SUB.Name
                    'VNET Name' = $VNET.Name
                    'VNET Range' = $Prefix
                    'VNET Location' = $VNET.Location
                    'DNS Servers'= $VNET.DhcpOptions.DnsServers -join ', '
                    'Connected devices' = ($VNET.Subnets.IpConfigurations.Id).Count
                }
            }
        $PumaVNET += $VNETInfo
        }
    }
    catch {
        Write-Output $error[0]
    }
}
$PumaVNET
Write-Output $PumaVNET | Export-Csv ".\automation.csv" -NoTypeInformation
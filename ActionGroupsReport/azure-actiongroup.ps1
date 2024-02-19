$Subscriptions = Get-AzSubscription
$ActionGroupsList = @()

foreach ($Subscription in $Subscriptions) {
    Write-Host "Processing Subscription: " $Subscription.Name -BackgroundColor Green
    try {
        Select-AzSubscription -Subscription $Subscription.SubscriptionID -ErrorAction Continue | Out-Null
        $ActionGroups = Get-AzActionGroup -WarningAction SilentlyContinue
        foreach ($Action in $ActionGroups) {
            $ActionGroupInfo = [PSCustomObject]@{
                'Subscription' = $Subscription.Name
                'Resource Group' = $Action.ResourceGroupName
                'Action Group Name' = $Action.Name
                'Short Name' = $Action.GroupShortName
                'Email Recipients' = $Action.EmailReceivers.EmailAddress -join ', '
            }
            $ActionGroupsList += $ActionGroupInfo
        }
    }
    catch {
        Write-Output $Error[0]
    }
}

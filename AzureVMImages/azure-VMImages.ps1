Connect-AzAccount

$AzureLocations = ("West Europe","East US","Brazil South","East Asia","South East Asia","Japan East","West Us2","Australia Central","Central India")
$AzureVMImgList = @()

foreach ($Location in $AzureLocations) {
    $ImagePublishers = Get-AzVMImagePublisher -Location $Location | Where-Object {($_.PublisherName -Like "MicrosoftWindowsServer") -or ($_.PublisherName -like "Canonical") -or ($_.PublisherName -like "RedHat")}
    foreach ($Publisher in $ImagePublishers) {
        $PublisherOffers = Get-AzVMImageOffer -PublisherName $Publisher.PublisherName -Location $Location
        foreach ($Offer in $PublisherOffers) {
            $OfferSkus = Get-AzVMImageSku -Offer $Offer.Offer -PublisherName $Publisher.PublisherName -Location $Location
            foreach ($sku in $OfferSkus) {
                $SKUList = [PSCustomObject]@{
                    'Publisher' = $Publisher.PublisherName
                    'Offer' = $Offer.Offer
                    'SKU' = $sku.Skus
                    'Location' = $Location
                }
                $AzureVMImgList += $SKUList
            }
        }
    }
}
$AzureVMImgList

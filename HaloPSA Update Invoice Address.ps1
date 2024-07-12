# Import the HaloAPI module
Import-Module HaloAPI

# Define the necessary variables
$TenantClientID = ""
$TenantClientSecret = ""
$TenantURL = "" # Ensure the trailing slash is included
$TenantName = ""

# Authenticate with the HaloPSA API
Connect-HaloAPI -ClientID "$TenantClientID" -URL "$TenantURL" -ClientSecret "$TenantClientSecret" -Tenant "$TenantName" -Scopes "all"

# Define the timezone to set
$timezone = "Eastern Standard Time"

# Function to get all sites
function Get-AllSites {
    $sites = Get-HaloSite
    return $sites
}

# Function to update the field "Invoice address is different from the Site Address"
function Update-SiteInvoiceAddress {
    param (
        [string]$siteId
    )
    $sitedata = @{
        id = $siteId
        invoiceAddressDifferentFromSite = $false
    }
    $result = Set-HaloSite -site $sitedata
    return $result
}

# Get all sites
$sites = Get-AllSites

# Update each site's "Invoice address is different from the Site Address" to false with status output and delay
foreach ($site in $sites) {
    Write-Output "Updating site $($site.id) to set 'Invoice address is different from the Site Address' to false..."
    $updateResult = Update-SiteInvoiceAddress -siteId $site.id
    
    if ($updateResult) {
        Write-Output "Successfully updated site $($site.id) to set 'Invoice address is different from the Site Address' to false"
    } else {
        Write-Output "Failed to update site $($site.id) to set 'Invoice address is different from the Site Address' to false"
    }

    Start-Sleep -Seconds 1
}

Write-Output "All sites have been processed."

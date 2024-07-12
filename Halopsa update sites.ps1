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

# Function to update a site's timezone
function Update-SiteTimezone {
    param (
        [string]$siteId,
        [string]$timezone
    )
    $sitedata = @{
        id = $siteId
        timezone = $timezone
    }
    $result = Set-HaloSite -site $sitedata
    return $result
}

# Get all sites
$sites = Get-AllSites

# Update each site's timezone to Eastern Time with status output and delay
foreach ($site in $sites) {
    Write-Output "Updating site $($site.id) to timezone $timezone..."
    $updateResult = Update-SiteTimezone -siteId $site.id -timezone $timezone
    
    if ($updateResult) {
        Write-Output "Successfully updated site $($site.id) to timezone $timezone"
    } else {
        Write-Output "Failed to update site $($site.id) to timezone $timezone"
    }

    Start-Sleep -Seconds 1
}

Write-Output "All sites have been processed."

function Get-UserListings {
    param (
        $userId
    )

    Write-Information "Fetching user listing "$userId
    #$url = "https://www.olx.in/profile/$userId"
    $url = "https://www.olx.in/api/v2/users/$userId/items?limit=18&status=ACTIVE&lang=en"
    $userResponse = Invoke-WebRequest $url
    $userListings = $userResponse.Content | ConvertFrom-Json | select -expand data | select id
    Write-Information "Fetched user listing "$userId
    return $userListings
}

function Get-Page {
    param (
        $pageNo
    )

    if ($pageNo -lt 1) {
        return
    }

    $olxPageNo = $pageno - 1

    Write-Information "Fetching page "$pageNo
    $api = "https://www.olx.in/api/relevance/v2/search?category=84&facet_limit=100&lang=en&location=4058526&location_facet_limit=20&page=$olxPageNo&platform=web-desktop&query=innova%20crysta&size=40&sorting=desc-creation&spellcheck=true&user=17a5407a436x4872a439"
    $apiResponse = Invoke-WebRequest $api
    $apiJson = $apiResponse.Content | ConvertFrom-Json
    $apiData = $apiJson | Select -expand data
    Write-Information "Fetched page "$pageNo
    return $apiData
}



for ($i = 1; $i -le 10; $i++)
{
    Get-Page $i | Where-Object { (Get-UserListings $_.user_id).Count -lt 3 } | ForEach-Object { 
        $itemUrl = "https://www.olx.in/item/$([System.Web.HttpUtility]::UrlEncode($_.title))-iid-$($_.id)"
        Write-Host $itemUrl
        [System.Diagnostics.Process]::Start("chrome", $itemUrl)
    }
}

<#
Get-Page 1 | Select-Object -First 2 | ForEach-Object { 
        $itemUrl = "https://www.olx.in/item/$(System.Web.HttpUtility]::UrlEncode($_.title))-iid-$($_.id)"
        Write-Host $itemUrl
        [System.Diagnostics.Process]::Start("chrome", $itemUrl)
    }
#>
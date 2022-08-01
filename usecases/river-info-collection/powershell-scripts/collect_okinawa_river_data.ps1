Function Main {
    $waterLevels,$rains = Fetch-RiverData
    $waterLevels = $(Filter-Past1Hour $waterLevels)
    $rains = $(Filter-Past1Hour $rains)
    Post-Data "dataops-cosmos" "OkinawaRiverInfo" "waterLevels" $waterLevels
    Post-Data "dataops-cosmos" "OkinawaRiverInfo" "rains" $rains
}

Function Fetch-RiverData {
    Write-Host "--河川水位データ(10分毎の水位と雨量)を取得"
    $response = Invoke-WebRequest "http://www.bousai.okinawa.jp/river/kasen/dat_js/DBDAT_dat.js"
    #UTF-8への変換とJSON化
    $formattedJsonText = [System.Text.Encoding]::UTF8.GetString([System.Text.Encoding]:: `
                         GetEncoding("UTF-8").GetBytes($response.Content.Replace("gDat = ", "").Replace(";", "")))
    #Hashtableへ変換
    $data = $(ConvertFrom-Json $formattedJsonText)
    Return $($data.rep_suii10min),$($data.rep_rain10min)
}

Function Filter-Past1Hour($items) {
    $toDate = Get-Date
    $fromDate = $toDate.AddHours(-1)
    $newItems = @()
    Foreach($item in $items){
        $dateTime = [Datetime]::ParseExact($item.tim, "MM/dd HH:mm", $null)
        If(($dateTime -lt $toDate) -And ($dateTime -gt $fromDate)) {
            $newItems += $item
        }
    }
    Return $newItems
}

Function Get-Token {
    Write-Host "--Instance Metadata Serviceからトークンを取得"
    $imdsUrl = "http://169.254.169.254/metadata/identity/oauth2/token"
    $queries = "?api-version=2018-02-01&resource=https://cosmos.azure.com"
    $headers = @{"Metadata"="true"}
    $response = (Invoke-RestMethod -Headers $headers -Method GET -Uri $imdsUrl$queries)
    Return $response.access_token
}

Function Post-Data($dbaccount,$db,$col,$data) {
    Write-Host "--Cosmos DBにデータを登録"
    $token = Get-Token
    $cosmosUrl = "https://"+$dbaccount+".documents.azure.com/dbs/"+$db+"/colls/"+$col+"/docs"
    Foreach($stations in $data){
        Foreach($station in $stations.sdat){
            If($col -eq "waterLevels") {
                $body = ConvertTo-Json(@{id=(New-Guid).Guid
                                         timestamp=[Datetime]::ParseExact($stations.tim, "MM/dd HH:mm", $null)
                                         sno=$station.sno
                                         waterLevel=$station.dat[0].dat})
            } ElseIf($col -eq "rains") {
                $body = ConvertTo-Json(@{id=(New-Guid).Guid
                                         timestamp=[Datetime]::ParseExact($stations.tim, "MM/dd HH:mm", $null)
                                         sno=$station.sno
                                         rain=$station.dat[0].dat})
            }
            $partitionkeyValue = $station.sno
            $headers = @{"authorization"="type%3daad%26ver%3d1.0%26sig%3d$token"
                         "x-ms-version"="2018-12-31"
                         "x-ms-documentdb-is-upsert"= "True"
                         "x-ms-documentdb-partitionkey"= "[$partitionkeyValue]"}
            Invoke-RestMethod -Uri $cosmosUrl -Method "POST" -Headers $headers -Body ([System.Text.Encoding]::UTF8.GetBytes($body)) -ContentType "appication/json"
        }
    }
}

Main

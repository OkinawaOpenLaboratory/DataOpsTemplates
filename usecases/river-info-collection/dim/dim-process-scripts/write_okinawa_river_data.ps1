Function Main($data) {
    $col = $data[0]
    Write-Host $col
    $data = $data[1..($data.Length-1)]
    Post-Data "dataops-cosmos" "OkinawaRiverInfo" $col $data
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
        $stations = [System.String]$stations
        $stations = $stations.Replace("tim:", '{"tim": "').Replace("sno", '"sno"').Replace("dat", '"dat"').Replace(',
 s"dat"', '",
 "sdat"').Replace("alm", '"alm"').Replace("updw", '"updw"').Replace("閉局",'"閉局"').Replace("欠測", '"欠測"') + "}"
        $stations = $(ConvertFrom-Json $stations)
        Foreach($station in $stations.sdat){
            If($col -eq "waterLevels") {
                $body = ConvertTo-Json(@{id=(New-Guid).Guid
                                        timestamp=[Datetime]::ParseExact($stations.tim, " MM/dd HH:mm", $null)
                                        sno=$station.sno
                                        waterLevel=$station.dat[0].dat})
            } ElseIf($col -eq "rains") {
                $body = ConvertTo-Json(@{id=(New-Guid).Guid
                                         timestamp=[Datetime]::ParseExact($stations.tim, " MM/dd HH:mm", $null)
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
Main -data $Args

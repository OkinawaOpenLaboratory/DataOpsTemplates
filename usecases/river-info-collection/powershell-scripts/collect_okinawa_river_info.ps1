Function Main {
    $okinawaRiverInfo = Fetch-RiverData
    Write-File $okinawaRiverInfo
}

Function Fetch-RiverData {
    Write-Host "--沖縄県河川情報システムから河川情報(緯度経度や危険水域)の取得"
    $gInfUrl = "http://www.bousai.okinawa.jp/river/kasen/dat_js/DBDAT_inf.js"
    $response = Invoke-WebRequest $gInfUrl
    Write-Host "--文字コードの変換と文字列の置換、Jsonオブジェクトに変換"
    $formattedJsonText = [System.Text.Encoding]::UTF8.GetString([System.Text.Encoding]:: `
                         GetEncoding("UTF-8").GetBytes($response.Content.Replace("gInf = ", "").Replace(";", "")))
    Return ConvertFrom-Json $formattedJsonText
}

Function Write-File([string]$jsonData, [string]$path = ".") {
    Write-Host "--JSONファイルの出力"
        $outputFilePath = $path+"\OkinawaRiverInfo\okinawa-river-info-latest.json"
        ConvertTo-Json $data -Depth 100 | Out-File (New-Item -Path $outputFilePath -Force)
        $outputFilePath = $path+"\OkinawaRiverInfo\okinawa-river-info-$(Get-Date -UFormat '%Y%m%d%H%M').json"
        ConvertTo-Json $data -Depth 100 | Out-File (New-Item -Path $outputFilePath -Force)
}

Main

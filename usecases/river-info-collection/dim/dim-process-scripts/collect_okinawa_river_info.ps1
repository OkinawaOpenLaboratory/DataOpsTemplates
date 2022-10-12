Function Main($filePath) {
    $okinawaRiverInfo = Fetch-RiverData -filePath $filePath
    Write-File $okinawaRiverInfo
}

Function Fetch-RiverData($filePath) {
    Write-Host "--沖縄県河川情報システムから河川情報(緯度経度や危険水域)の取得"
    $rawData = Get-Content -Path $filePath -RAW 
    Write-Host "--文字コードの変換と文字列の置換、Jsonオブジェクトに変換"
    $formattedJsonText = [System.Text.Encoding]::UTF8.GetString([System.Text.Encoding]:: `
                         GetEncoding("UTF-8").GetBytes($rawData.Replace("gInf = ", "").Replace(";", "")))
    Write-Host($formattedJsonText)
    Return ConvertFrom-Json $formattedJsonText
}

Function Write-File($jsonData, [string]$path = ".") {
    Write-Host "--JSONファイルの出力"
        $outputFilePath = $path+"\OkinawaRiverInfo\okinawa-river-info-latest.json"
        ConvertTo-Json $jsonData -Depth 100 | Out-File (New-Item -Path $outputFilePath -Force)
        $outputFilePath = $path+"\OkinawaRiverInfo\okinawa-river-info-$(Get-Date -UFormat '%Y%m%d%H%M').json"
        ConvertTo-Json $jsonData -Depth 100 | Out-File (New-Item -Path $outputFilePath -Force)
}

Main -filePath $Args[0]

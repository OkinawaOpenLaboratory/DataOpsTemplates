Function Main($filePath) {
    $waterLevels,$rains = Fetch-RiverDataFile -filePath $filePath
    $waterLevels = $(Filter-Past1Hour $waterLevels)
    $rains = $(Filter-Past1Hour $rains)
    $executeCommand = "-command C:\Users\dataops_user\DataOpsTemplates\usecases\river-info-collection\dim\dim-process-scripts\write_okinawa_river_data.ps1 'waterLevels' $waterLevels"
    Start-Process -FilePath pwsh.exe -ArgumentList $executeCommand -Wait -NoNewWindow
    $executeCommand = "-command C:\Users\dataops_user\DataOpsTemplates\usecases\river-info-collection\dim\dim-process-scripts\write_okinawa_river_data.ps1 'rains' $rains"
    Start-Process -FilePath pwsh.exe -ArgumentList $executeCommand -Wait -NoNewWindow

}

Function Fetch-RiverDataFile($filePath) {
    Write-Host "--河川水位データ(10分毎の水位と雨量)を読込"
    # TODO: データのパスはコマンドライン引数で取得する
    $rawData = Get-Content -Path $filePath -RAW 
    #UTF-8への変換とJSON化
    $formattedJsonText = [System.Text.Encoding]::UTF8.GetString([System.Text.Encoding]:: `
                         GetEncoding("UTF-8").GetBytes($rawData.Replace("gDat = ", "").Replace(";", "")))
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
            $item = ConvertTo-Json($item) -Depth 5
            $newItems += $item
        }
    }
    Return $newItems
}

Main -filePath $Args[0]
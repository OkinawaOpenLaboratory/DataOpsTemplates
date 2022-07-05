#沖縄県河川情報システムサイトから水位・雨量データの取得
$gDatUrl = "http://www.bousai.okinawa.jp/river/kasen/dat_js/DBDAT_dat.js"
$response = Invoke-WebRequest $gDatUrl
#文字コードの変換と文字列の置換
$formattedJsonText = [System.Text.Encoding]::UTF8.GetString([System.Text.Encoding]:: `
                     GetEncoding("UTF-8").GetBytes($response.Content.Replace("gDat = ", "").Replace(";", "")))
#JSONオブジェクトに変換
$data =  ConvertFrom-Json $formattedJsonText
#JSONファイルの出力
ConvertTo-Json $data -Depth 10 | Out-File "~\Documents\OkinawaRiverData\okinawa-river-data-latest.json"
ConvertTo-Json $data -Depth 10 | Out-File "~\Documents\OkinawaRiverData\okinawa-river-data-$(Get-Date -UFormat "%Y%m%d%H%M").json"

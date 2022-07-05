#沖縄県河川情報システムから河川情報(緯度経度や危険水域)の取得
$gInfUrl = "http://www.bousai.okinawa.jp/river/kasen/dat_js/DBDAT_inf.js"
$response = Invoke-WebRequest $gInfUrl
#文字コードの変換と文字列の置換
$formattedJsonText = [System.Text.Encoding]::UTF8.GetString([System.Text.Encoding]:: `
                     GetEncoding("UTF-8").GetBytes($response.Content.Replace("gInf = ", "").Replace(";", "")))
#JSONオブジェクトに変換
$data =  ConvertFrom-Json $formattedJsonText
#JSONファイルの出力
ConvertTo-Json $data -Depth 10 | Out-File "~\Documents\OkinawaRiverInfo\okinawa-river-info-latest.json"
ConvertTo-Json $data -Depth 10 | Out-File "~\Documents\OkinawaRiverInfo\okinawa-river-info-$(Get-Date -UFormat "%Y%m%d%H%M").json"

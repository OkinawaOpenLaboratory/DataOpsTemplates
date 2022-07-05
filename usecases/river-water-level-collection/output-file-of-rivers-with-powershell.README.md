# Power Shell を使用した河川データの収集

Power Shell を使用し[沖縄県河川情報システム](http://www.bousai.okinawa.jp/river/kasen/)の複数河川の①水位・雨量データ(DADAT_dat.js)、②緯度経度や危険水域のデータ（DBDAT_inf.js）を JSON 形式のファイルで取得します。

![image](https://user-images.githubusercontent.com/73327236/177265977-88a6210e-0175-4a5a-a0a3-15d6becff1da.png)

## 事前準備

事前に VM 上に Power Shell 7.2.5　をインストールしてください

## 設定方法

### 1. データ収集するPower Shell スクリプトの設定

河川データを収集する2つのスクリプトファイルをダウンロードし、実行します。

#### 1.1 Power Shell スクリプトのダウンロード

河川データ収集で使用する下記の Power Shell スクリプトファイルをダウンロードします。

| スクリプトファイル名 | 概要 |
| --- | --- |
| [get_okinawa_river_data.ps1](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-water-level-collection/powershell-script/get_okinawa_river_data.ps1) | 沖縄県河川情報システムから複数河川の水位・雨量データを取得し、JSON形式のファイルで出力する |
| [get_okinawa_river_info.ps1](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-water-level-collection/powershell-script/get_okinawa_river_info.ps1) | 沖縄県河川情報システムから河川の緯度経度や危険水域を取得し、JSON形式のファイルで出力する |

VM 上の検索画面から PowerShell を立ち上げます。

![image](https://user-images.githubusercontent.com/73327236/177271665-1fc76b91-a24a-4640-96f3-9b7c182b3f21.png)

Power Shell で以下のコマンドを入力し、スクリプトファイルのダウンロードします。

[get_okinawa_river_data.ps1](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-water-level-collection/powershell-script/get_okinawa_river_data.ps1)

```
mkdir  ~\Documents\OkinawaRiverData
curl https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-water-level-collection/powershell-script/get_okinawa_river_data.ps1 > ~\Documents\OkinawaRiverData\get_okinawa_river_data.ps1
```

![image](https://user-images.githubusercontent.com/73327236/177278761-ba3065a4-2863-4c65-b38e-5b3dc3178c3a.png)

[get_okinawa_river_info.ps1](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-water-level-collection/powershell-script/get_okinawa_river_info.ps1) 

```
mkdir  ~\Documents\OkinawaRiverData
curl https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-water-level-collection/powershell-script/get_okinawa_river_info.ps1 > ~\Documents\OkinawaRiverInfo\get_okinawa_river_info.ps1
```

![image](https://user-images.githubusercontent.com/73327236/177279363-2f8d322b-b0ee-4295-97a5-6f96027db483.png)

#### 1.2 Power Shell スクリプトファイルの実行

Power Shell でダウンロードしたスクリプトファイルを下記のコマンドで実行します。

[get_okinawa_river_data.ps1](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-water-level-collection/powershell-script/get_okinawa_river_data.ps1)を Power Shell で実行します。

```
~\Documents\OkinawaRiverData\get_okinawa_river_data.ps1
```

![image](https://user-images.githubusercontent.com/73327236/177284290-5006996a-0011-483d-9c85-9c0a27073706.png)

[get_okinawa_river_info.ps1](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-water-level-collection/powershell-script/get_okinawa_river_info.ps1) を Power Shell で実行します。

```
~\Documents\OkinawaRiverInfo\get_okinawa_river_info.ps1
```

![image](https://user-images.githubusercontent.com/73327236/177284893-792490fd-ce76-42a9-a4a0-be2b8e0f99aa.png)

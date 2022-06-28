# Power Shell を使用した河川データの収集

Power Shell を使用し[沖縄県河川情報システム](http://www.bousai.okinawa.jp/river/kasen/)の複数河川の①水位・雨量データ(DBDAT_dat.js)、②観測所の緯度経度や危険水位のデータ（DBDAT_inf.js）を JSON 形式のファイルで取得します。

![image](https://user-images.githubusercontent.com/73327236/182054171-6200c435-66c0-4435-b63b-aba38ec90d66.png)

## 事前準備

1. [DataOps deployment for okinawa river info](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/tree/main/dataops-deployment-of-okinawa-river-info)を使用し、本ユースケースで使用する環境をデプロイしてください。

2. VM 上に Power Shell 7をインストールしてください。(Power Shell のバージョンは7.2.5で動作確認しています。)

3. Azure Power Shell をインストールしてください。(Azure Power Shell のバージョンは7.2.2で動作確認しています。)

## 設定方法

### 1. マネージド ID の設定

まずマネージド ID を設定します。

#### 1.1. マネージド ID のオブジェクト ID の確認

Azure Portal で「マネージド ID 」を検索し、マネージド ID の管理画面を開きます。
「pad-cosmos-read-write」のオブジェクト(プリンシパル) ID をコピーします。

![image](https://user-images.githubusercontent.com/73327236/174906682-7c4db55f-c8b5-405b-91b4-28cdd1bd5a0e.png)

#### 1.2. マネージド ID へのロールの付与

Power Shell を使用し、Azure Power Shell にログインします。

```
Connect-AzAccount
```

ログイン後、以下のコマンドを実行し、仮想マシンに割り当てたマネージド ID に対して、組み込みロールを付与します。

変数名と値は以下のように設定します。

| 変数名 | 値 |
| --- | --- |
| resourceGroupName | <リソースグループ名> |
| accountName  | dataops-cosmos |
| cosmosDBReadWriteRoleDefinitionID | 00000000-0000-0000-0000-000000000002 |
| principalId | <マネージド ID のオブジェクト(プリンシパル) ID> |

```
$resourceGroupName= "<リソースグループ名>"
$accountName = "dataops-cosmos"
$cosmosDBReadWriteRoleDefinitionID = "00000000-0000-0000-0000-000000000002"
$principalId = "<マネージド ID のオブジェクト(プリンシパル) ID>"

New-AzCosmosDBSqlRoleAssignment -AccountName $accountName `
  -ResourceGroupName $resourceGroupName `
  -RoleDefinitionId $cosmosDBReadWirteRoleDefinitionID `
  -Scope "/" `
  -PrincipalId $principalId
```

以上がマネージド ID の設定になります。次に データ収集を行う PowerShellスクリプト の設定を行います。

### 2. データ収集するPower Shell スクリプトの設定

河川データを収集する2つのスクリプトファイルをダウンロードし、実行します。

#### 2.1 Power Shell スクリプトのダウンロード

河川データ収集で使用する下記の Power Shell スクリプトファイルをダウンロードします。

| スクリプトファイル名 | 概要 |
| --- | --- |
| [collect_okinawa_river_data.ps1](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-info-collection/powershell-scripts/collect_okinawa_river_data.ps1) | 沖縄県河川情報システムから複数河川の水位・雨量データを取得し、Cosmos DBに登録する |
| [collect_okinawa_river_info.ps1](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-info-collection/powershell-scripts/collect_okinawa_river_info.ps1) | 沖縄県河川情報システムから観測所の緯度経度や危険水位を取得し、JSON形式のファイルで出力する |

VM 上の検索画面から PowerShell を立ち上げます。

![image](https://user-images.githubusercontent.com/73327236/177271665-1fc76b91-a24a-4640-96f3-9b7c182b3f21.png)

Power Shell で以下のコマンドを入力し、スクリプトファイルのダウンロードします。

[collect_okinawa_river_data.ps1](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-info-collection/powershell-scripts/collect_okinawa_river_data.ps1)

```
curl https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-info-collection/powershell-scripts/collect_okinawa_river_data.ps1 > ~\Documents\collect_okinawa_river_data.ps1
```

![image](https://user-images.githubusercontent.com/73327236/182060309-5eff4cf2-6f82-4317-aac6-e57895b3ee81.png)

[collect_okinawa_river_info.ps1](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-info-collection/powershell-scripts/collect_okinawa_river_info.ps1)

```
curl https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-info-collection/powershell-scripts/collect_okinawa_river_info.ps1 > ~\Documents\collect_okinawa_river_data.ps1
```

![image](https://user-images.githubusercontent.com/73327236/182060393-78243785-d8f7-41d7-af2f-fd690a3ed658.png)

#### 2.2 Power Shell スクリプトファイルの実行

[collect_okinawa_river_data.ps1](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-info-collection/powershell-scripts/collect_okinawa_river_data.ps1)を タスクスケジューラで1時間ごとに実行します。

検索画面からタスク スケジューラを立ち上げます。

![image](https://user-images.githubusercontent.com/73327236/173044264-90489187-7261-4d4c-8d3f-1efef8259be2.png)

タスク スケジューラが起動したらタスク スケジューラ ライブラリを選択し、画面右の「タスクの作成...」を選択します。

![image](https://user-images.githubusercontent.com/73327236/173044617-90b8bdd7-9fcf-401d-b2ef-38c7f17d6763.png)

タスクの作成画面で各項目の設定で作成します。

全般を設定します。

| 設定項目 | 値 |
| --- | --- |
| 名前 | 河川水位・雨量収集 |
| 説明 | 空欄 |
| セキュリティオプション | ユーザーがログオンしている時のみ実行するを選択 |

![image](https://user-images.githubusercontent.com/73327236/180671642-819e1075-91fb-4cd0-b14d-4973c712fce2.png)

トリガーを設定します。

新規ボタンを選択し、以下の設定を行います。
| 設定項目 | 値 |
| --- | --- |
| タスクの開始 | スケジュールに従う |
| 設定 | 1回 |
| 開始日 | 実行する日時、時間(時間は〇〇:00が好ましい) |
| 繰り返し時間 | 1時間 |
| 継続時間 | 無制限 |

![image](https://user-images.githubusercontent.com/73327236/173045185-e9499e27-d6a5-466a-a5ea-12138b8f92b1.png)

![image](https://user-images.githubusercontent.com/73327236/180671780-fd1d0953-df61-4b79-ad0a-ef7682d83056.png)

操作を設定します。

新規ボタンを選択し、以下の設定を行います。

| 設定項目 | 値 |
| --- | --- |
| プログラム/スクリプト | "C:\Program Files\PowerShell\7\pwsh.exe" |
| 引数の追加 | -Command "C:\Users\dataops_user\Documents\collect_okinawa_river_data.ps１" |

![image](https://user-images.githubusercontent.com/73327236/173045553-2392e0e3-9553-4525-8237-556abe2b8795.png)

![image](https://user-images.githubusercontent.com/73327236/182054557-b3c9a8b9-7b06-48ba-8c3b-117b0c8c0cc2.png)

条件はデフォルト設定のままにします。

![image](https://user-images.githubusercontent.com/73327236/173045963-d61bd810-6fc7-4e7e-bc53-ca926e5e363e.png)

設定はデフォルト設定のままにします。

![image](https://user-images.githubusercontent.com/73327236/173046240-f31bdb4d-6429-41a0-977d-81b01aa5d642.png)

タスク一覧から作成したタスクを右クリックし、「実行する」を選択します。

![image](https://user-images.githubusercontent.com/73327236/173046521-0e25db79-faef-4bc5-b061-dedb659ff659.png)

collect_okinawa_river_data.ps１　の実行は以上です。

続いて、ダウンロードした [collect_okinawa_river_info.ps1](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-info-collection/powershell-scripts/collect_okinawa_river_info.ps1)　をPowerShellで実行します。

```
~\Documents\collect_okinawa_river_info.ps1
```

![image](https://user-images.githubusercontent.com/73327236/182060467-a315b688-ce0a-48a9-887b-9ded02ad4349.png)

データを収集するPowerShellスクリプトの設定は以上になります。


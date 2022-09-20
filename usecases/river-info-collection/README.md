# 沖縄県河川情報データ可視化ユースケース

Power Shell 、Power BI Desktop を使用し[沖縄県河川情報システム](http://www.bousai.okinawa.jp/river/kasen/)の複数河川の①水位・雨量データ(DBDAT_dat.js)、②観測所の緯度経度や危険水位のデータ（DBDAT_inf.js）を可視化します。

![image](https://user-images.githubusercontent.com/73327236/182054171-6200c435-66c0-4435-b63b-aba38ec90d66.png)

## 事前準備

1. [DataOps deployment for okinawa river info](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/tree/main/dataops-deployment-for-okinawa-river-info) を使用し、本ユースケースで使用する環境をデプロイしてください。

2. VM 上に Power Shell 7をインストールしてください。(Power Shell のバージョンは7.2.5で動作確認しています。)

3. Azure Power Shell をインストールしてください。(Azure Power Shell のバージョンは7.2.2で動作確認しています。)

4. VM上の言語を日本語、タイムゾーンを大阪、札幌、東京に設定してください。

## 設定方法

### 1. マネージド ID の設定

まずマネージド ID を設定します。

#### 1.1. マネージド ID のオブジェクト ID の確認

Azure Portal で「マネージド ID 」を検索し、マネージド ID の管理画面を開きます。
「cosmosdb-read-write」のオブジェクト(プリンシパル) ID をコピーします。

![image](https://user-images.githubusercontent.com/73327236/191675895-d0a827e2-c13b-4d3b-8359-efa61b05b99f.png)

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
  -RoleDefinitionId $cosmosDBReadWriteRoleDefinitionID `
  -Scope "/" `
  -PrincipalId $principalId
```

以上がマネージド ID の設定になります。次にデータ収集を行う PowerShellスクリプト の設定を行います。

### 2. データ収集するPower Shell スクリプトの設定

河川データを収集する2つのスクリプトファイルをダウンロードし、実行します。

#### 2.1 Power Shell スクリプトのダウンロード

河川データ収集で使用する下記の Power Shell スクリプトファイルをダウンロードします。

| スクリプトファイル名 | 概要 |
| --- | --- |
| [collect_okinawa_river_data.ps1](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-info-collection/powershell-scripts/collect_okinawa_river_data.ps1) | 沖縄県河川情報システムから複数河川の水位・雨量データを取得し、Cosmos DBに登録する |
| [collect_okinawa_river_info.ps1](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-info-collection/powershell-scripts/collect_okinawa_river_info.ps1) | 沖縄県河川情報システムから観測所の緯度経度や危険水位を取得し、JSON形式のファイルで出力する |

VM 上の検索画面からコマンド プロンプトを立ち上げます。

![image](https://user-images.githubusercontent.com/73327236/191367222-7d238152-b79c-4736-b7a9-64297832f701.png)

コマンド プロンプトで以下のコマンドを入力し、スクリプトファイルのダウンロードします。

[collect_okinawa_river_data.ps1](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-info-collection/powershell-scripts/collect_okinawa_river_data.ps1)

```
curl https://raw.githubusercontent.com/OkinawaOpenLaboratory/DataOpsTemplates/main/usecases/river-info-collection/powershell-scripts/collect_okinawa_river_data.ps1 > .\Documents\collect_okinawa_river_data.ps1
```

![image](https://user-images.githubusercontent.com/73327236/191367732-ac7dc3a9-a5ec-48f4-8596-2c5e11bd9077.png)

[collect_okinawa_river_info.ps1](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-info-collection/powershell-scripts/collect_okinawa_river_info.ps1)

```
curl https://raw.githubusercontent.com/OkinawaOpenLaboratory/DataOpsTemplates/main/usecases/river-info-collection/powershell-scripts/collect_okinawa_river_info.ps1 > .\Documents\collect_okinawa_river_info.ps1
```

![image](https://user-images.githubusercontent.com/73327236/191368198-11842a21-cfc3-426d-9e87-25914e5bb744.png)

#### 2.2 Power Shell スクリプトファイルの実行

[collect_okinawa_river_data.ps1](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-info-collection/powershell-scripts/collect_okinawa_river_data.ps1)をタスクスケジューラで1時間ごとに実行します。

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

collect_okinawa_river_data.ps1 の実行は以上です。

続いて、ダウンロードした [collect_okinawa_river_info.ps1] (https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-info-collection/powershell-scripts/collect_okinawa_river_info.ps1)を PowerShell で実行します。

```
~\Documents\collect_okinawa_river_info.ps1
```

![image](https://user-images.githubusercontent.com/73327236/182060467-a315b688-ce0a-48a9-887b-9ded02ad4349.png)

データを収集する PowerShell スクリプトの設定は以上になります。

次に収集した河川情報を可視化する Power BI Desktop の設定を行います。

### 3. Power BI Desktop の設定

#### 3.1. PBIX ファイルのダウンロード

河川水位データダッシュボードの [PBIX ファイル](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-water-level-collection/power-bi-dashboard/water-level-dashboard.pbix)をダウンロードします。

#### 3.2. PBIX ファイルの読み込み

Power BI Desktop を起動し、「ファイル」→「レポートを開く」→「レポートの参照」から、ダウンロードした河川水位データダッシュボードの PBIX ファイルを開きます。

![image](https://user-images.githubusercontent.com/73327236/191370675-8beded81-62fc-42c3-8959-ddf6e3830015.png)

PBIX ファイルの読み込みが完了すると、ダッシュボードが表示されます。

#### 3.3. 読み取り専用プライマリキーの取得

Cosmos DB データソースから河川水位データを取得するには、Cosmos DB が発行する読み取り専用プライマリキーを設定する必要があります。
読み取り専用プライマリキーは Azure Portal から確認できます。

![image](https://user-images.githubusercontent.com/8349954/172524002-7d5a68a4-53a4-41de-a8b4-eef9b4c4fe5c.png)

#### 3.4. 読み取り専用プライマリキーの設定

Power BI Desktop で「データの更新」を押します。

![image](https://user-images.githubusercontent.com/73327236/191378704-0bd26004-4f5b-4063-9c33-b2291f315249.png)

アカウントキーの入力が求められるので、読み取り専用プライマリキーを入力します。

![image](https://user-images.githubusercontent.com/8349954/172524207-5d9c74fa-e015-4b39-ab17-8850fba696ca.png)

#### 3.5. マップビジュアルのセキュリティ設定
現在の設定ではマップが表示できるよう設定を変更します。「ファイル」→ 「オプションと設定」→ 「オプション」→「グローバル配下のセキュリティ」を開き、ArcGIS for Power BI の「地図と塗り分け地図の画像を使用する」にチェックボタンを押します。

![image](https://user-images.githubusercontent.com/73327236/191378768-67adc47b-dd62-4e7d-bb90-1e95d267e136.png)

チェック後、マップビジュアルが表示されていることを確認します。

![image](https://user-images.githubusercontent.com/73327236/191379022-da628fb5-2973-4ecf-9541-eda49bb59fda.png)

以上で、Power BI Desktop の設定は完了です。

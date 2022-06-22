# 河川水位データ可視化ユースケース

## 事前準備

事前に Google Chrome をインストールし、Microsoft Power Automate Extension を有効にしてください。

## 設定方法

### 1. Power Automate Desktop の設定

このドキュメントでは、Cosmos DB のプライマリーキーを使用したデータ登録を説明します。

ユーザー割り当てマネージド ID を使用したデータ登録の方法は[こちら](https://raw.githubusercontent.com/OkinawaOpenLaboratory/DataOpsTemplates/main/usecases/river-water-level-collection/write-data-with-manaaged-id/README.md)を参照してください。 

#### 1.1. 新しいフローの作成

Power Automate Desktop を起動し、新しいフローを作成します。

※ 初回起動時にサインインを求められた場合は、お持ちの Microsoft アカウントでサインインしてください。

<img width="915" alt="image" src="https://user-images.githubusercontent.com/8349954/172269075-c5e032ef-d347-4c06-abdf-3a6c56a00c53.png">

#### 1.2. メインフローのコピー

[メインフロー](https://raw.githubusercontent.com/OkinawaOpenLaboratory/DataOpsTemplates/main/usecases/river-water-level-collection/power-automate-flow/flow.robin)を全選択し、コピーします。

<img width="1175" alt="image" src="https://user-images.githubusercontent.com/8349954/172268359-5801cabb-f941-4db1-b4b4-3e8c096d0163.png">

#### 1.3. メインフローの貼り付け

メインフローをフローエディターへ貼り付けます。(Ctrl+V)

<img width="1364" alt="image" src="https://user-images.githubusercontent.com/8349954/172269577-07b067c4-0455-47da-8bc1-9db08f6ac8a0.png">

#### 1.4. エラー通知サブフローのコピー

[エラー通知サブフロー](https://raw.githubusercontent.com/OkinawaOpenLaboratory/DataOpsTemplates/main/usecases/river-water-level-collection/power-automate-flow/error-notify.robin)を全選択し、コピーします。

<img width="1180" alt="image" src="https://user-images.githubusercontent.com/8349954/172268735-c8be0a6b-5364-49b8-b961-d5d64e5961d7.png">

#### 1.5. エラー通知サブフローの貼り付け

エラー通知サブフローをフローエディターへ貼り付けます。

<img width="949" alt="image" src="https://user-images.githubusercontent.com/8349954/172270636-52ab6a09-cd4c-4d33-95a1-e999ff51363d.png">

#### 1.6. アクションの設定

Mainフロー内の以下のアクション番号をダブルクリックし変数に対しての値を設定します。

| アクション番号 | 変数 | 値 |
| --- | --- | --- |
| 1 | resourceType | docs |
| 2 | resourceLink | dbs/OkinawaRiverDB/colls/benoki |
| 3 | primaryKey | Azure Portal から取得した Cosmos DB のプライマリキー |

<img width="629" alt="image" src="https://user-images.githubusercontent.com/73327236/172785824-8f3ffb94-df02-4c0b-9f3a-81110b758071.png">
<img width="632" alt="image" src="https://user-images.githubusercontent.com/73327236/172791998-325efbe2-70ee-4b0a-87a0-df93e078f37e.png">
<img width="632" alt="image" src="https://user-images.githubusercontent.com/73327236/172786153-a581c11f-60b6-424b-a2b8-5b191226a0dc.png">

以上で、Power Automate Desktop の設定は完了です。

### 2. タスク スケジューラの設定

Power Automate Desktop で作成したフローを1時間毎に実行できるよう、タスク スケジューラの設定を行います。

#### 2.1. PowerShellスクリプトファイルのダウンロード

タスク スケジューラで実行する [PowerShellスクリプトファイル](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-water-level-collection/power-automate-flow/startPADFlow.ps1)をダウンロードします。検索画面から PowerShell を立ち上げ、以下のコマンドを入力し、実行します。

```
curl https://raw.githubusercontent.com/OkinawaOpenLaboratory/DataOpsTemplates/main/usecases/river-water-level-collection/power-automate-flow/startPADFlow.ps1 > ~/Downloads/startPADFlow.ps1
```

![image](https://user-images.githubusercontent.com/73327236/173043743-2bbaf0f0-39db-4d9d-a786-6ca9523fdb14.png)

![image](https://user-images.githubusercontent.com/73327236/173043934-a514b258-7fc8-4072-8cbe-5fa0234a69a5.png)

#### 2.2. タスクの作成

検索画面からタスク スケジューラを立ち上げます。

![image](https://user-images.githubusercontent.com/73327236/173044264-90489187-7261-4d4c-8d3f-1efef8259be2.png)

タスク スケジューラが起動したらタスク スケジューラ ライブラリを選択し、画面右の「タスクの作成...」を選択します。

![image](https://user-images.githubusercontent.com/73327236/173044617-90b8bdd7-9fcf-401d-b2ef-38c7f17d6763.png)

タスクの作成画面で各項目の設定で作成します。

全般を設定します。

| 設定項目 | 値 |
| --- | --- |
| 名前 | 河川水位収集フロー |
| 説明 | 空欄 |
| セキュリティオプション | ユーザーがログオンしている時のみ実行するを選択 |

![image](https://user-images.githubusercontent.com/73327236/173044912-52f3ba04-e07f-4a5f-94b8-bad7b9cdd9c4.png)

トリガーを設定します。

新規ボタンを選択し、以下の設定を行います。
| 設定項目 | 値 |
| --- | --- |
| タスクの開始 | スケジュールに従う |
| 設定 | 1回 |
| 開始日 | 実行する日時、時間(時間は河川水位サイトのデータ更新後の〇〇:30が好ましい) |
| 繰り返し時間 | 1時間 |
| 継続時間 | 無制限 |


![image](https://user-images.githubusercontent.com/73327236/173045185-e9499e27-d6a5-466a-a5ea-12138b8f92b1.png)

![image](https://user-images.githubusercontent.com/73327236/173045253-7f449127-8520-439b-a0f4-3aa7a5d4fd47.png)

操作を設定します。

新規ボタンを選択し、以下の設定を行います。

| 設定項目 | 値 |
| --- | --- |
| プログラム/スクリプト | C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe |
| 引数の追加 | -Command "C:\Users\dataops-user\Downloads\startPADFlow.ps1 -flowName <Power Automate Desktopのフロー名>" |

![image](https://user-images.githubusercontent.com/73327236/173045553-2392e0e3-9553-4525-8237-556abe2b8795.png)

![image](https://user-images.githubusercontent.com/73327236/173045865-ceaaf37a-2e39-4c6d-b4d4-55413f028437.png)

条件はデフォルト設定のままにします。

![image](https://user-images.githubusercontent.com/73327236/173045963-d61bd810-6fc7-4e7e-bc53-ca926e5e363e.png)

設定はデフォルト設定のままにします。

![image](https://user-images.githubusercontent.com/73327236/173046240-f31bdb4d-6429-41a0-977d-81b01aa5d642.png)

#### 2.3. タスクの実行

タスク一覧から作成したタスクを右クリックし、「実行する」を選択します。

![image](https://user-images.githubusercontent.com/73327236/173046521-0e25db79-faef-4bc5-b061-dedb659ff659.png)

タスク スケジューラの設定は以上です。


次に1時間毎に収集した河川のデータを可視化するため、 Power BI Desktop の設定を行います。

### 3. Power BI Desktop の設定

#### 3.1. PBIX ファイルのダウンロード

河川水位データダッシュボードの [PBIX ファイル](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-water-level-collection/power-bi-dashboard/water-level-dashboard.pbix)をダウンロードします。

![image](https://user-images.githubusercontent.com/8349954/172521089-51831fe0-8281-40eb-aa79-153ef210603c.png)

#### 3.2. PBIX ファイルの読み込み

Power BI Desktop を起動し、「ファイル」→「レポートを開く」→「レポートの参照」から、ダウンロードした河川水位データダッシュボードの PBIX ファイルを開きます。

![image](https://user-images.githubusercontent.com/8349954/172522202-4b767e7c-c70e-4e7d-84f2-a029b64716f7.png)

PBIX ファイルの読み込みが完了すると、ダッシュボードが表示されます。

#### 3.3. 読み取り専用プライマリキーの取得

Cosmos DB データソースから河川水位データを取得するには、Cosmos DBが発行する読み取り専用プライマリキーを設定する必要があります。
読み取り専用プライマリキーは Azure Portal から確認できます。

![image](https://user-images.githubusercontent.com/8349954/172524002-7d5a68a4-53a4-41de-a8b4-eef9b4c4fe5c.png)

#### 3.4. 読み取り専用プライマリキーの設定

Power BI Desktop で「データの更新」を押します。

![image](https://user-images.githubusercontent.com/8349954/172522987-46526630-d445-4043-adf3-bf24103f8b64.png)

アカウントキーの入力が求められるので、読み取り専用プライマリキーを入力します。

![image](https://user-images.githubusercontent.com/8349954/172524207-5d9c74fa-e015-4b39-ab17-8850fba696ca.png)

以上で、Power BI Desktop の設定は完了です。



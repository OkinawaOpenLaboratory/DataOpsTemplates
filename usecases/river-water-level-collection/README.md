# 河川水位データ可視化ユースケース

## 事前準備

事前に Google Chrome をインストールし、Microsoft Power Automate Extension を有効にしてください。

## 設定方法

### Power Automate Desktop の設定

#### 1. 新しいフローの作成

Power Automate Desktop を起動し、新しいフローを作成します。

※ 初回起動時にサインインを求められた場合は、お持ちの Microsoft アカウントでサインインしてください。

<img width="915" alt="image" src="https://user-images.githubusercontent.com/8349954/172269075-c5e032ef-d347-4c06-abdf-3a6c56a00c53.png">

#### 2. メインフローのコピー

[メインフロー](https://raw.githubusercontent.com/OkinawaOpenLaboratory/DataOpsTemplates/main/usecases/river-water-level-collection/power-automate-flow/flow.robin)を全選択し、コピーします。

<img width="1175" alt="image" src="https://user-images.githubusercontent.com/8349954/172268359-5801cabb-f941-4db1-b4b4-3e8c096d0163.png">

#### 3. メインフローの貼り付け

メインフローをフローエディターへ貼り付けます。(Ctrl+V)

<img width="1364" alt="image" src="https://user-images.githubusercontent.com/8349954/172269577-07b067c4-0455-47da-8bc1-9db08f6ac8a0.png">

#### 4. エラー通知サブフローのコピー

[エラー通知サブフロー](https://raw.githubusercontent.com/OkinawaOpenLaboratory/DataOpsTemplates/main/usecases/river-water-level-collection/power-automate-flow/error-notify.robin)を全選択し、コピーします。

<img width="1180" alt="image" src="https://user-images.githubusercontent.com/8349954/172268735-c8be0a6b-5364-49b8-b961-d5d64e5961d7.png">

#### 5. エラー通知サブフローの貼り付け

エラー通知サブフローをフローエディターへ貼り付けます。

<img width="949" alt="image" src="https://user-images.githubusercontent.com/8349954/172270636-52ab6a09-cd4c-4d33-95a1-e999ff51363d.png">

#### 6. 入力変数の設定

入力変数を設定します。

| 入力変数 | 設定値 |
| --- | --- |
| resourceType | docs |
| resourceLink | dbs/OkinawaRiverDB/colls/benoki |
| primaryKey | Azure Portal から取得した Cosmos DB のプライマリキー |

<img width="629" alt="image" src="https://user-images.githubusercontent.com/8349954/172270003-fb9c3700-466d-4fe4-8311-2bd833b6c3d4.png">
<img width="632" alt="image" src="https://user-images.githubusercontent.com/8349954/172270192-85e78810-064a-4c15-8414-1e4597a08775.png">
<img width="632" alt="image" src="https://user-images.githubusercontent.com/8349954/172270336-68f44c9b-c5c3-495b-ac40-90c6d575286f.png">

以上で、Power Automate Desktop の設定は完了です。

### Power BI Desktop の設定

#### 1. PBIX ファイルのダウンロード

河川水位データダッシュボードの [PBIX ファイル](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/blob/main/usecases/river-water-level-collection/power-bi-dashboard/water-level-dashboard.pbix)をダウンロードします。

![image](https://user-images.githubusercontent.com/8349954/172521089-51831fe0-8281-40eb-aa79-153ef210603c.png)

#### 2. PBIX ファイルの読み込み

Power BI Desktop を起動し、「ファイル」→「レポートを開く」→「レポートの参照」から、ダウンロードした河川水位データダッシュボードの PBIX ファイルを開きます。

![image](https://user-images.githubusercontent.com/8349954/172522202-4b767e7c-c70e-4e7d-84f2-a029b64716f7.png)

PBIX ファイルの読み込みが完了すると、ダッシュボードが表示されます。

#### 3. 読み取り専用プライマリキーの取得

Cosmos DB データソースから河川水位データを取得するには、Cosmos DBが発行する読み取り専用プライマリキーを設定する必要があります。
読み取り専用プライマリキーは Azure Portal から確認できます。

![image](https://user-images.githubusercontent.com/8349954/172524002-7d5a68a4-53a4-41de-a8b4-eef9b4c4fe5c.png)

#### 4. 読み取り専用プライマリキーの設定

Power BI Desktop で「データの更新」を押します。

![image](https://user-images.githubusercontent.com/8349954/172522987-46526630-d445-4043-adf3-bf24103f8b64.png)

アカウントキーの入力が求められるので、読み取り専用プライマリキーを入力します。

![image](https://user-images.githubusercontent.com/8349954/172524207-5d9c74fa-e015-4b39-ab17-8850fba696ca.png)

以上で、Power BI Desktop の設定は完了です。

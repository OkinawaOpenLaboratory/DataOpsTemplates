# RBAC を使用した河川水位データの登録

## 事前準備

事前に Google Chrome をインストールし、Microsoft Power Automate Extension を有効にしてください。

また、Azure Power Shell をインストールしてください。

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

以上がマネージド ID の設定になります。次に Power Automate Desktop の設定を行います。

### 2. Power Automate Desktop の設定

マネージド ID を紐付けた VM 上で Cosmos DB にデータを登録するフローを作成します。

#### 2.1. 新しいフローの作成

Power Automate Desktop を起動し、新しいフローを作成します。

※ 初回起動時にサインインを求められた場合は、お持ちの Microsoft アカウントでサインインしてください。

<img width="915" alt="image" src="https://user-images.githubusercontent.com/8349954/172269075-c5e032ef-d347-4c06-abdf-3a6c56a00c53.png">

#### 2.2. メインフローのコピー

[メインフロー](https://raw.githubusercontent.com/OkinawaOpenLaboratory/DataOpsTemplates/main/usecases/river-water-level-collection/power-automate-flow/flow-with-managed-id.robin)を全選択し、コピーします。

<img width="1180" alt="image" src="https://user-images.githubusercontent.com/73327236/174957344-0bd58c6f-fefb-4cb1-9157-30f9181c3b3e.png">

#### 2.3. メインフローの貼り付け

メインフローをフローエディターへ貼り付けます。(Ctrl+V)

<img width="1364" alt="image" src="https://user-images.githubusercontent.com/73327236/174956521-52ae1804-cde2-42d5-939d-5f12d44acc6b.png">

#### 2.4. エラー通知サブフローのコピー

[エラー通知サブフロー](https://raw.githubusercontent.com/OkinawaOpenLaboratory/DataOpsTemplates/main/usecases/river-water-level-collection/power-automate-flow/error-notify.robin)を全選択し、コピーします。

<img width="1180" alt="image" src="https://user-images.githubusercontent.com/8349954/172268735-c8be0a6b-5364-49b8-b961-d5d64e5961d7.png">

#### 2.5. エラー通知サブフローの貼り付け

エラー通知サブフローをフローエディターへ貼り付けます。

<img width="949" alt="image" src="https://user-images.githubusercontent.com/8349954/172270636-52ab6a09-cd4c-4d33-95a1-e999ff51363d.png">

以上で、Power Automate Desktop の設定は完了です。

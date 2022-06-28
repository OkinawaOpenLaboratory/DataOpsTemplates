# DataOps テンプレート

## 概要

このリポジトリは、[DataOps](https://www.gartner.com/en/information-technology/glossary/dataops) の環境を簡単に構築するための ARM テンプレートを提供します。

## ユースケースの種類

| ユースケース | 説明 | テンプレートの種類 |
| ------------ | ---- | ------------- |
| [河川水位データ可視化ユースケース](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/tree/main/usecases/river-water-level-collection) | 国土交通省の公開している河川水位データを収集し可視化する |  ●[DataOps deployment](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/tree/main/dataops-deployment)<br>●[DataOps deployment with managed id](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/tree/main/dataops-deployment-with-managed-id)<br>●[DataOps deployment with automated bastion lifecycle](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/tree/main/dataops-deployment-with-automated-bastion-lifecycle)|
| [沖縄県河川情報データ可視化ユースケース](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/tree/main/usecases/river-info-collection) |[沖縄県河川情報システム](http://www.bousai.okinawa.jp/river/kasen/)が公開している河川水位・雨量データを収集し可視化する | [dataops-deployment-for-okinawa-river-info](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/tree/main/dataops-deployment-of-okinawa-river-info) |

## テンプレートの種類

### - [DataOps deployment](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/tree/main/dataops-deployment)

DataOps deployment は、[河川水位データ可視化ユースケース](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/tree/main/usecases/river-water-level-collection)に必要な以下のリソースを自動的に展開します。

- Virtual Machine (Windows Server 2022)
- Bastion
- CosmosDB

展開された Windows Server には、Power Automate Desktop と Power BI Desktop が自動的にインストールされます。

### - [DataOps deployment with managed id](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/tree/main/dataops-deployment-with-managed-id)

DataOps deployment with managed id は、Power Automate Desktop から Cosmos DB へ接続するための認証に Azure Managed ID を使用できるテンプレートです。DataOps Deployment の構成に加えて、Azure Managed ID の定義が含まれます。

- Virtual Machine (Windows Server 2022)
- Bastion
- CosmosDB
- User Assigned Managed ID

### - [DataOps deployment with automated bastion lifecycle](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/tree/main/dataops-deployment-with-automated-bastion-lifecycle)

DataOps deployment with automated bastion lifecycle は、 DataOps deployment の構成に加えて、Azure Bastion を指定した時間に自動的に作成・削除するための Azure Automation の定義が含まれます。

- Virtual Machine (Windows Server 2022)
- Bastion
- CosmosDB
- Automation

### - [Data0ps deployment for okinawa river info](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/tree/main/dataops-deployment-of-okinawa-river-info) 

Data0ps deployment for okinawa river info は、[沖縄県河川情報データ可視化ユースケース](https://github.com/OkinawaOpenLaboratory/DataOpsTemplates/tree/main/usecases/river-info-collection)に必要な以下のリソースを自動的に展開します。

- Virtual Machine (Windows Server 2022)
- Bastion
- CosmosDB
- User Assigned Managed ID

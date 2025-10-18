# 🚀 Fintech Lakehouse for Fraud Detection on Azure

This repository contains the complete infrastructure, data pipeline, and machine learning code for a scalable fintech lakehouse designed for real-time fraud detection and customer insights. The project leverages a modern data stack on Microsoft Azure, fully automated with Infrastructure as Code (IaC) and CI/CD pipelines.

---

## 📚 Table of Contents
- [Architecture Overview](#-architecture-overview)
- [Technology Stack](#-technology-stack)
- [Project Structure](#-project-structure)
- [Setup and Deployment](#-setup-and-deployment)
- [Data Pipeline Workflow](#-data-pipeline-workflow)
- [CI/CD Automation](#-cicd-automation)

---

## 🏗️ Architecture Overview
The architecture ingests raw financial transaction data, processes it through a multi-stage medallion architecture in Databricks, trains a machine learning model to detect fraud, and generates summary reports for business intelligence.

- **Infrastructure**: Defined via Terraform for repeatable, version-controlled deployments.  
- **Orchestration**: Azure Data Factory (ADF) triggers Databricks jobs on a schedule.  
- **Processing & ML**: Azure Databricks handles data cleaning, feature engineering, model training (MLflow), and batch prediction.  
- **Storage**: Azure Data Lake Storage Gen2 stores data in Delta Lake format across Bronze, Silver, and Gold layers.  
- **Security**: Azure Key Vault stores credentials accessed via a managed Service Principal.  

---

## 🧰 Technology Stack

| Component | Technology | Purpose |
| ---------- | ----------- | -------- |
| **Cloud Provider** | Microsoft Azure | Core cloud platform for all services |
| **IaC** | Terraform & Terraform Cloud | Automating provisioning of Azure resources |
| **Data Lake** | Azure Data Lake Storage (ADLS) Gen2 | Scalable storage for raw, processed, and curated data |
| **Data Format** | Delta Lake | ACID transactions, time travel, and reliability |
| **ETL & ML** | Azure Databricks & Apache Spark | Data transformation, feature engineering, ML model training |
| **MLOps** | MLflow | Experiment tracking, model logging, and registry |
| **Orchestration** | Azure Data Factory (ADF) | Scheduling and orchestrating the data pipeline |
| **Security** | Azure Key Vault | Secure storage and management of secrets |
| **CI/CD** | GitHub Actions | Automated deployment of Databricks notebooks |

---

## 📁 Project Structure

```
.
├── .github/
│   └── workflows/              # GitHub Actions CI/CD pipeline for notebook deployment
│       └── deploy.yml
├── notebooks/                  # All Databricks notebooks (source of truth)
│   ├── 01_ingest_to_delta.ipynb
│   ├── 02_clean_transform.ipynb
│   ├── 03_feature_engineering.py
│   ├── 04_train_fraud_model.py
│   └── 05_fraud_summary.py
├── terraform/                  # Terraform code for all Azure infrastructure
│   ├── main.tf
│   └── variables.tf
└── README.md                   # This file
```


## ⚙️ Setup and Deployment
Follow these steps to deploy the entire infrastructure and solution.

1. Prerequisites  
   - An Azure subscription  
   - A Terraform Cloud account  
   - A GitHub account  

2. Azure Service Principal  
   Create an Azure Service Principal (`sp-finlake-deployer`) with Contributor access to your Azure subscription. This is used by Terraform Cloud to deploy resources.

3. Terraform Cloud Configuration  
   - Create a Terraform Cloud workspace and link it to this GitHub repository.  
   - In the workspace Variables, add the credentials for the service principal as Environment Variables. Mark `ARM_CLIENT_SECRET` as Sensitive.  
     ```
     ARM_CLIENT_ID  
     ARM_CLIENT_SECRET  
     ARM_TENANT_ID  
     ARM_SUBSCRIPTION_ID  
     ```

4. GitHub Secrets for Notebook Deployment  
   In this repository, go to **Settings > Secrets and variables > Actions** and add the following secrets:  
   - `DATABRICKS_HOST`: The URL of your Azure Databricks workspace  
   - `DATABRICKS_TOKEN`: A Databricks Personal Access Token (PAT) with repository access permissions  

## 🔄 Data Pipeline Workflow
The ADF pipeline orchestrates the following sequence of Databricks notebooks:

1. **Ingestion** (`01_ingest_to_delta`): Ingests raw data into a Bronze Delta table.  
2. **Cleaning** (`02_clean_transform`): Cleans the raw data and writes to a Silver Delta table.  
3. **Feature Engineering** (`03_feature_engineering`): Creates advanced behavioral features (e.g., transaction velocity, Z-scores).  
4. **Model Training & Prediction** (`04_train_fraud_model`):  
   - Handles severe class imbalance  
   - Trains a LightGBM model  
   - Uses MLflow to track experiments, log metrics, and register the model  
   - Performs batch prediction on the full daily dataset  
5. **Summarization** (`05_fraud_summary`): Aggregates predictions into an hourly summary table with business KPIs, writing to a Gold Delta table for reporting  

## 🔁 CI/CD Automation
- **Terraform Cloud**: Manages the infrastructure lifecycle. Any push to `main` with changes in `/terraform` triggers Terraform Cloud to apply updates.  
- **GitHub Actions**: Manages the application code lifecycle. Any push to `main` with changes in `/notebooks` triggers the workflow in `.github/workflows/deploy.yml` to sync notebooks to Databricks.  



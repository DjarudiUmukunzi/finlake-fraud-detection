Fintech Lakehouse for Fraud Detection on Azure

This repository contains the complete infrastructure, data pipeline, and machine learning code for a scalable fintech lakehouse designed for real-time fraud detection and customer insights. The project leverages a modern data stack on Microsoft Azure, fully automated with Infrastructure as Code (IaC) and CI/CD pipelines.

Table of Contents

Architecture Overview

Technology Stack

Project Structure

Setup and Deployment

Data Pipeline Workflow

CI/CD Automation

Architecture Overview

The architecture is designed to ingest raw financial transaction data, process it through a multi-stage medallion architecture in Databricks, train a machine learning model to identify fraudulent activities, and generate aggregated summary reports for business intelligence.

Infrastructure: All Azure resources are defined and managed using Terraform for repeatable, version-controlled deployments.

Orchestration: Azure Data Factory (ADF) orchestrates the end-to-end workflow, triggering Databricks jobs on a schedule.

Processing & ML: Azure Databricks serves as the core processing engine, handling data cleaning, advanced feature engineering, model training (with MLflow), and batch prediction.

Storage: Azure Data Lake Storage (ADLS Gen2) is used as the data lake, storing data in the efficient Delta Lake format across Bronze (raw), Silver (cleaned), and Gold (aggregated) layers.

Security: Azure Key Vault securely stores all credentials, which are accessed by services via a managed Service Principal, ensuring no secrets are ever exposed in code.

Technology Stack

Component

Technology

Purpose

Cloud Provider

Microsoft Azure

Core cloud platform for all services.

IaC

Terraform & Terraform Cloud

Automating the provisioning of all Azure resources.

Data Lake

Azure Data Lake Storage (ADLS) Gen2

Scalable storage for raw, processed, and curated data.

Data Format

Delta Lake

ACID transactions, time travel, and reliability on ADLS.

ETL & ML

Azure Databricks & Apache Spark

Data transformation, feature engineering, ML model training.

MLOps

MLflow

Experiment tracking, model logging, and registry.

Orchestration

Azure Data Factory (ADF)

Scheduling and orchestrating the data pipeline.

Security

Azure Key Vault

Secure storage and management of secrets.

CI/CD

GitHub Actions

Automated deployment of Databricks notebooks.

Project Structure

.
├── .github/workflows/      # GitHub Actions CI/CD pipeline for notebook deployment
│   └── deploy.yml
├── notebooks/              # All Databricks notebooks (source of truth)
│   ├── 01_ingest_to_delta.ipynb
│   ├── 02_clean_transform.ipynb
│   ├── 03_feature_engineering_pro.py
│   ├── 04_train_fraud_model_pro.py
│   └── 05_fraud_summary_pro.py
├── terraform/              # Terraform code for all Azure infrastructure
│   ├── main.tf
│   └── variables.tf
└── README.md               # This file



Setup and Deployment

Follow these steps to deploy the entire infrastructure and solution from scratch.

1. Prerequisites

An Azure subscription.

A Terraform Cloud account.

A GitHub account.

Azure CLI and Terraform CLI installed locally for initial setup.

2. Azure Service Principal

Create an Azure Service Principal (sp-finlake-deployer) with Contributor access to your Azure subscription. This service principal will be used by Terraform Cloud to deploy resources.

3. Terraform Cloud Configuration

Create a new workspace in your Terraform Cloud organization.

Link this workspace to your GitHub repository (DjarudiUmukunzi/finlake-fraud-detection).

In the workspace Variables, add the credentials for your service principal as Environment Variables. Ensure ARM_CLIENT_SECRET is marked as Sensitive.

ARM_CLIENT_ID

ARM_CLIENT_SECRET

ARM_TENANT_ID

ARM_SUBSCRIPTION_ID

4. GitHub Secrets for Notebook Deployment

In your GitHub repository, go to Settings > Secrets and variables > Actions and add the following secrets for the GitHub Actions workflow:

DATABRICKS_HOST: The URL of your Azure Databricks workspace (e.g., https://adb-....azuredatabricks.net).

DATABRICKS_TOKEN: A Personal Access Token (PAT) generated from your Databricks user settings with repository access.

5. Deployment

The deployment is fully automated:

Infrastructure: Any push to the main branch with changes in the /terraform directory will trigger a run in Terraform Cloud to apply the infrastructure changes.

Notebooks: Any push to the main branch with changes in the /notebooks directory will trigger the GitHub Actions workflow to deploy the updated notebooks to the Databricks workspace.

Data Pipeline Workflow

The ADF pipeline orchestrates the following sequence of Databricks notebooks:

01_ingest_to_delta: Ingests raw CSV data into a Bronze Delta table.

02_clean_transform: Cleans the raw data, handles nulls, and saves it to a Silver Delta table.

03_feature_engineering_pro: Reads the cleaned data and creates advanced behavioral features (e.g., transaction velocity, Z-scores) at a transaction level, crucial for accurate fraud detection.

04_train_fraud_model_pro:

Handles the severe class imbalance in the data.

Trains a high-performance LightGBM model.

Uses MLflow to track the experiment, log metrics (AUPRC, AUROC), and register the final model.

Performs batch prediction on the full daily dataset and saves predictions.

05_fraud_summary_pro: Aggregates the transaction-level predictions into an hourly summary table with key business KPIs (e.g., fraud rate by count, fraud rate by value), saving it to a Gold Delta table for BI and reporting.

CI/CD Automation

This project uses a hybrid automation approach for a professional MLOps workflow:

Terraform Cloud: Manages the lifecycle of the cloud infrastructure based on the code in the /terraform directory. It provides a robust, secure, and auditable way to manage infrastructure state.

GitHub Actions: Manages the application code lifecycle. The workflow in .github/workflows/deploy.yml is responsible for syncing the Databricks notebooks from the /notebooks directory in this repository to the Databricks workspace, ensuring the code running in production is always the version committed to the main branch.

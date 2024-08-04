# bigquery-python-bash-automation
Since we can only retrieve data from our website through the Google Analytics API for the last 60 days, I would like to demonstrate in this repository how to run BigQuery queries in Python and automate it using crontab for collecting historical data.

# BigQuery automation with python and bash

Since we can only retrieve data from our website through the Google Analytics API for the last 60 days, I would like to demonstrate in this repository how to run BigQuery queries in Python and automate it using bash and crontab for collecting historical data.
## Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Usage](#usage)
- [Automating with Bash](#automating-with-bash)
- [Contributing](#contributing)
- [License](#license)

## Introduction

This project provides a comprehensive guide and scripts to:

- Connect to BigQuery from Python.
- Run SQL queries on BigQuery using Python.
- Automate Python scripts with bash for scheduled or repeated tasks.

(#1 Note that the project assumes we already have the Google Cloud API set up and can query the data collected by Analytics through BigQuery. Setting up the API can be done quite easily based on [this video](https://www.youtube.com/watch?v=HbxIXEfl-Hs&list=LL&index=21).)

(#2 Note that the python and bash script is automatically executed using [crontab](https://linuxhandbook.com/crontab/), so the project can be applied most easily on Linux or Mac systems where crontab is available by default.)

## Prerequisites

First you need to set up Application Default Credentials (ADC) for your environment.

Here are the steps to set up ADC:
**1. Create a Service Account:**
	- Go to the Google Cloud Console: https://console.cloud.google.com/
	- Select your project.
	- Navigate to IAM & Admin > Service accounts.
	- Click Create Service Account.
	- Provide a name and description for the service account, and click Create.
	- Assign the BigQuery Admin role to the service account, and click Continue.
	- Click Done.
 
**2. Download the Service Account Key:**
	- Find the newly created service account in the list.
	- Click the Actions column (three vertical dots) for the service account, then select Manage keys.
	- Click Add key > Create new key.
	- Choose JSON and click Create. This will download the JSON key file to your computer.
 
 **3. Open terminal and paste the followings:**

`pip install google-cloud-bigquery db-dtypes`

`pip3 install db-dtypes`

`export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/service-account-file.json"`

if the following code returns the path provided in the previous command, then the setup was successful:

`echo $GOOGLE_APPLICATION_CREDENTIALS`

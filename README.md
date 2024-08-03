# bigquery-python-automation
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

Simply install the following.

`pip install google-cloud-bigquery db-dtypes`

`pip3 install db-dtypes`



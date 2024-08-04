# bigquery-python-bash-automation

Since we're using the free version, we can only get data from our website through the Google Analytics API for the last 60 days, I would like to demonstrate in this repository how to run BigQuery queries in Python and automate it using bash and crontab for collecting historical data.

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

> **Note:** The project assumes you already have the Google Cloud API set up and can query the data collected by Analytics through BigQuery. Setting up the API can be done quite easily based on [this video](https://www.youtube.com/watch?v=HbxIXEfl-Hs&list=LL&index=21). If you don't have a website set up with GA4, then based on [this repository](https://github.com/ngchub/Google-Cloud-Workshops/blob/main/.Exploring%20Your%20Ecommerce%20Dataset%20with%20SQL%20in%20Google%20BigQuery/Ecommerce_Practice_Notebook.md), you can easily see what a dataset collected about webshop visitors looks like and make queries. The project folders contain data queried from this demo database.

> **Note:** The Python and bash scripts are automatically executed using [crontab](https://linuxhandbook.com/crontab/), so the project is best applied on Linux or Mac systems where crontab is available by default.

## Prerequisites

First, you need to set up Application Default Credentials (ADC) for your environment.

### Steps to Set Up ADC

1. **Create a Service Account:**
    - Go to the [Google Cloud Console](https://console.cloud.google.com/).
    - Select your project.
    - Navigate to IAM & Admin > Service accounts.
    - Click Create Service Account.
    - Provide a name and description for the service account, and click Create.
    - Assign the BigQuery Admin role to the service account, and click Continue.
    - Click Done.

2. **Download the Service Account Key:**
    - Find the newly created service account in the list.
    - Click the Actions column (three vertical dots) for the service account, then select Manage keys.
    - Click Add key > Create new key.
    - Choose JSON and click Create. This will download the JSON key file to your computer.

3. **Configure Your Environment:**
    ```sh
    pip install google-cloud-bigquery db-dtypes
    pip3 install db-dtypes
    export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/bigquery-python-bash-automation/service-account-file.json"
    ```
    Verify the setup:
    ```sh
    echo $GOOGLE_APPLICATION_CREDENTIALS
    ```

## Setup

### Running the Python Script

1. **Python Script:**
    Save the following script as `run_bigquery.py` in the `bigquery-python-bash-automation` folder:

    ```python
    import os
    from google.cloud import bigquery
    import pandas as pd
    from datetime import datetime
    
    # Set up BigQuery client
    client = bigquery.Client()
    
    # Function to run a query and save results as TSV
    def run_query_and_save_to_tsv(query, output_file):
        # Execute the query
        query_job = client.query(query)
        results = query_job.result()
        
        # Convert results to a Pandas DataFrame
        df = results.to_dataframe()
        
        # Save DataFrame to TSV
        df.to_csv(output_file, sep='\t', index=False)
    
    # List of query file names with descriptive names
    query_files = {
        "customers": "customers.sql",
        "non_customers": "noncustomers.sql"
        # Add more descriptive query names and their corresponding SQL file names here
    }
    
    # Directory containing the SQL query files
    input_queries_dir = "input_bq_sql_queries"
    
    # Read the queries from their respective SQL files
    queries = {}
    for descriptive_name, file_name in query_files.items():
        query_file_path = os.path.join(input_queries_dir, file_name)
        with open(query_file_path, 'r') as file:
            queries[descriptive_name] = file.read()
    
    # Directory to save TSV files
    output_dir = "/Users/petishrooly/Documents/bigquery-python-bash-automation/output_tables"
    os.makedirs(output_dir, exist_ok=True)
    
    # Run each query and save the result
    for descriptive_name, query in queries.items():
        # Get the current date and time
        current_time = datetime.now().strftime("%Y%m%d_%H%M%S")
        # Construct the output file name with date and time
        output_file = os.path.join(output_dir, f"{descriptive_name}_{current_time}.tsv")
        run_query_and_save_to_tsv(query, output_file)
        print(f"Saved results of '{descriptive_name}' to {output_file}")

    ```

2. **SQL Query Files:**
    Create a directory named `input_bq_sql_queries` inside `bigquery-python-bash-automation` and add your SQL query files there. Example:
    - `customers_event_data.sql`
    - `visitors_who_reach_checkout.sql`

### Running the Bash Script

1. **Bash Script:**
    Save the following script as `merge_files.sh` in the `bigquery-python-bash-automation` folder:

    ```sh
    #!/bin/bash

    # Set the input directories
    input_dir1="path/to/your/bigquery-python-bash-automation/output_tables"

    # Set the output directory
    output_dir="path/to/your/bigquery-python-bash-automation/merged_table"

    # Ensure the output directory exists
    mkdir -p "$output_dir"

    # Temporary files for processing
    temp_file1=$(mktemp)
    temp_file2=$(mktemp)

    # Append and merge customer event data files without duplicates
    cat "$input_dir1"/cu*.tsv > "$temp_file1"
    awk -F'\t' '!seen[$0]++' "$temp_file1" > "$output_dir/customers_event_data_MERGED.tsv"

    # Append and merge visitors who reach checkout files without duplicates
    cat "$input_dir1"/vi*.tsv > "$temp_file2"
    awk -F'\t' '!seen[$0]++' "$temp_file2" > "$output_dir/visitors_who_reach_checkout_MERGED.tsv"

    # Cleanup temporary files
    rm "$temp_file1" "$temp_file2"

    echo "Appended and merged customer event data file saved to: $output_dir/customers_event_data_MERGED.tsv"
    echo "Appended and merged visitors who reach checkout file saved to: $output_dir/visitors_who_reach_checkout_MERGED.tsv"

    # Optional: Navigate to the output directory
    cd "$output_dir"
    ```

2. **Make the Bash Script Executable:**
    ```sh
    chmod +x /path/to/your/bigquery-python-bash-automation/merge_files.sh
    ```

## Usage

1. **Run the Python Script:**
    ```sh
    python3 /path/to/your/bigquery-python-bash-automation/run_bigquery.py
    ```
    This will execute the queries and save the results as TSV files in the specified output directory.

2. **Run the Bash Script:**
    ```sh
    bash /path/to/your/bigquery-python-bash-automation/merge_files.sh
    ```
    This will merge the TSV files and save them in the `merged_table` directory.

## Automating with Bash

To automate the execution of the Python and Bash scripts, you can use `crontab`.

1. **Edit Crontab:**
    ```sh
    crontab -e
    ```

2. **Add the following lines:**
    ```sh
    0 2 * * * /usr/bin/python /path/to/your/bigquery-python-bash-automation/run_bigquery.py
    0 3 * * * /bin/bash /path/to/your/bigquery-python-bash-automation/merge_files.sh
    ```
    This schedule runs the Python script daily at 2 AM and the Bash script daily at 3 AM. Adjust the paths and schedule as needed.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

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
    "non_customers": "non_customers.sql"
    # Add more descriptive query names and their corresponding SQL file names here
}

# Directory containing the SQL query files
input_queries_dir = "/Users/petishrooly/Documents/bigquery-python-bash-automation/input_bq_sql_queries"

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

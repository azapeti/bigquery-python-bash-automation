#!/bin/bash

# Set the input directories
input_dir1="/Users/petishrooly/Documents/bigquery-python-bash-automation/output_tables"

# Set the output directory
output_dir="/Users/petishrooly/Documents/bigquery-python-bash-automation/merged_table"

# Ensure the output directory exists
mkdir -p "$output_dir"

# Temporary files for processing
temp_file1=$(mktemp)
temp_file2=$(mktemp)

# Append and merge customer event data files without duplicates
cat "$input_dir1"/cust*.tsv > "$temp_file1"
awk -F'\t' '!seen[$0]++' "$temp_file1" > "$output_dir/customers_MERGED.tsv"

# Append and merge visitors who reach checkout files without duplicates
cat "$input_dir1"/non*.tsv > "$temp_file2"
awk -F'\t' '!seen[$0]++' "$temp_file2" > "$output_dir/non_customers_MERGED.tsv"

# Cleanup temporary files
rm "$temp_file1"  "$temp_file2"

echo "Appended and merged customer event data file saved to: $output_dir/customers_MERGED.tsv"
echo "Appended and merged visitors who reach checkout file saved to: $output_dir/non_customers_MERGED.tsv"

# Optional: Navigate to the output directory
cd "$output_dir"

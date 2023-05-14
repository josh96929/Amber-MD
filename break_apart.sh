#!/bin/bash

input_file="$1"

# Check if the input file argument is provided
if [ -z "$input_file" ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

# Loop through each line in the input file
while IFS= read -r line; do
    # Extract the first column (field) from the line
    col1=$(echo "$line" | cut -d ',' -f 1)

    # Create a new file named after the first column with ".csv" extension
    output_file="${col1}.csv"

    # Write the entire line to the output file
    echo "$line" >> "$output_file"
done < "$input_file"


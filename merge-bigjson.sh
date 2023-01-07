#!/bin/sh

# Merge all json output files into one big json file
# Usage: merge-bigjson.sh <output_file> <input_dir>

# Check if jq is installed
if ! [ -x "$(command -v jq)" ]; then
    echo "Error: jq is not installed"
    return 1 2>/dev/null || exit 1
fi

# Check arguments
if [ $# -lt 2 ]; then
    echo "Usage: merge-bigjson.sh <output_file> <input_dir>"
    return 1 2>/dev/null || exit 1
fi

# Get output file
output=$1

# Get input directory
input=$2

# Check if input directory exists
if [ ! -d $input ]; then
    echo "Input directory $input does not exist"
    return 1 2>/dev/null || exit 1
fi

# Merge input directory
for file in $input/*; do
    # Get file name
    filename=$(basename $file)

    # Check if file is a directory
    if [ -d $file ]; then
        # Recursively merge directories
        ./merge-bigjson.sh $output $input/$filename
    elif [ -f $file ]; then
        # Merge files : we need to parse JSON
        # Get file content
        content=$(cat $file)

        # Check if file is empty
        if [ -z "$content" ]; then
            continue
        fi

        # Merge all elements in 'content' array to 'output' array
        jq -s '.[0] + .[1]' $output $file >$output.tmp 2>/dev/null
        mv $output.tmp $output

    fi
done

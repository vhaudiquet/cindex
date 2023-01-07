#!/bin/sh

# Merge multiple indexer output into one output
# Usage: merge.sh <output> <input1> <input2>

# Check if jq is installed
if ! [ -x "$(command -v jq)" ]; then
    echo "Error: jq is not installed"
    return 1 2>/dev/null || exit 1
fi

# Check arguments
if [ $# -lt 3 ]; then
    echo "Usage: merge.sh <output> <input1> <input2>"
    return 1 2>/dev/null || exit 1
fi

# Get output directory
output=$1

# Check if output directory exists
if [ -d $output ]; then
    echo "Output directory (${output}) already exists"
    return 1 2>/dev/null || exit 1
fi

# Create output directory
mkdir -p $output

# Get input directories
input1=$2
input2=$3

# Check if input directories exist
if [ ! -d $input1 ]; then
    echo "Input directory $input1 does not exist"
    return 1 2>/dev/null || exit 1
fi
if [ ! -d $input2 ]; then
    echo "Input directory $input2 does not exist"
    return 1 2>/dev/null || exit 1
fi

# Merge input directories
for file in $input1/*; do
    # Get file name
    filename=$(basename $file)

    # Check if file is a directory
    if [ -d $file ]; then
        if [ ! -d $input2/$filename ]; then
            # Output warning
            echo "Warning: $filename (dir) does not exist in $input2"
        else
            # Recursively merge directories
            ./merge.sh $output/$filename $input1/$filename $input2/$filename
        fi
    elif [ -f $input2/$filename ]; then
        # Merge files : we need to parse JSON and merge objects
        # Adding field of the first file to the second file
        sample=$(cat $file)
        sample2=$(cat $input2/$filename)
        out=()

        for e in $(echo "${sample}" | jq -r '.[] | @base64'); do
            e_field=$(echo $e | base64 --decode)
            # Obtain 'name' field
            name=$(echo $e_field | jq -r '.name')

            # Check if name == "null" : we skip {} fields
            if [ "$name" == "null" ]; then
                continue
            fi

            # Find if field exists in second file
            k=$(echo "${sample2}" | jq -r ".[] | select(.name == \"${name}\")" 2>/dev/null)
            if [ ! -z "${k}" ]; then
                # Field exists, we need to merge
                # Get field from second file
                field=$k #$(echo "${sample2}" | jq -r ".[] | select(.name == \"$name\")")

                # Merge fields
                field=$(echo $field | jq -c ". + $e_field")

                # Add field to output
                out+=($field)
            else
                # Output warning
                echo "Warning: $name field ($e_field) does not exist in $input2/$filename"
            fi
        done

        # Write merged file
        echo "${out[@]}" | jq -s '.' >$output/$filename
    else
        # Output warning
        echo "Warning: $filename does not exist in $input2"
        # Copy file
        cp $file $output/$filename
    fi
done

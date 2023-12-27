#!/bin/bash

# Check if at least two parameters are provided
if [ "$#" -lt 2 ]; then
    echo "Usage: $0 output_file input_file1 [input_file2 ...]"
    exit 1
fi

# Specify the output combined .cbz file name
output_file="$1"
[ -f ${output_file} ] && rm ${output_file}
shift

# Create a temporary directory to extract the contents
temp_dir=$(mktemp -d)

part=0
for file in "$@"; do
    unzip -q "$file" -d "${temp_dir}/${part}" &
    ((part++))
done
wait

cd ${temp_dir}

for i in $(seq "0" "$((part - 1))")
do    
    for img_file in $(ls ${i})
    do
        mv ${i}/${img_file} ${i}${img_file}
    done
    # Directory should be empty by now
    rmdir ${i}
done

zip -qr "$output_file" "."
echo "New cbz file created: $output_file"

rm -rf ${temp_dir}
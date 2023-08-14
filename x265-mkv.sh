#!/bin/bash

# Function to compress an .mkv file
compress_mkv() {
    # Check if the required arguments are provided
    if [ "$#" -ne 2 ]; then
        echo "Usage: compress_mkv input_file.mkv output_file.mkv"
        return 1
    fi

    local input_file="$1"
    local output_file="$2"

    # Check if the input file exists
    if [ ! -f "$input_file" ]; then
        echo "Input file $input_file not found."
        return 1
    fi

    # Use ffmpeg to compress the video while keeping subtitles and audio tracks
    ffmpeg -i "$input_file" -map 0 -c:v libx265 -crf 28 -c:a copy -c:s copy "$output_file"

    # Check if ffmpeg command was successful
    if [ $? -eq 0 ]; then
        echo "Compression successful. Output saved in $output_file"
    else
        echo "Compression failed."
    fi
}


IFS=$'\n'

# Set directory
cd $1

# Create within file's directory 
OUT_DIR=$(realpath $1)/x265
mkdir -pv ${OUT_DIR}
 
for file in *mkv
do
    # Convert if output file does not exist
    [ -f ${OUT_DIR}/$(basename ${file}) ] || compress_mkv ${file} ${OUT_DIR}/$(basename ${file})
done

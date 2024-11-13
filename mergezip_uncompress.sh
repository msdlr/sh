#!/bin/sh

to_zip=$(ls *.zip* | sed 's/.zip.*/.zip/g' | uniq )

[ "$to_zip" = "" ] && exit

echo "$to_zip" | while IFS= read -r zip_file; do
    rm -fv "$zip_file"
    echo "Merging $zip_file ($(ls "$zip_file"* | wc -l) parts)" 
    cat "$zip_file"* > "$zip_file"
    echo "Uncompressing $zip_file..."
    unzip -o "$zip_file" 
    
    if [ $? -eq 0 ]
    then
        notify-send "$zip_file" "Uncompressed " 2>/dev/null
        rm -v "$zip_file".*
        rm -v "$zip_file"
    fi
done

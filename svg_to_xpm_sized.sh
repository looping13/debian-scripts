#!/bin/bash

# Check if Inkscape and ImageMagick are installed
if ! command -v inkscape &> /dev/null; then
    echo "Inkscape is not installed. Please install it first."
    exit 1
fi
if ! command -v convert &> /dev/null; then
    echo "ImageMagick (convert) is not installed. Please install it first."
    exit 1
fi

# Check if input directory is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 /path/to/svg/directory"
    exit 1
fi

input_dir="$1"
output_dir="${input_dir}/xpm_output"
mkdir -p "$output_dir"

# Find all SVG files recursively and process them
find "$input_dir" -type f -name "*.svg" | while read -r svg_file; do
    rel_path="${svg_file#$input_dir/}"
    base_name="$(basename "${rel_path%.svg}")"
    output_path="$output_dir/$(dirname "$rel_path")"
    mkdir -p "$output_dir/$(dirname "$rel_path")"

    echo "Processing $svg_file"

    # Export to 32x32 XPM
    inkscape "$svg_file" --export-filename="/tmp/${base_name}_32.png" --export-width=32 --export-height=32 >/dev/null 2>&1
    convert "/tmp/${base_name}_32.png" "$output_path/${base_name}_32x32.xpm"

    # Export to 16x16 XPM
    inkscape "$svg_file" --export-filename="/tmp/${base_name}_16.png" --export-width=16 --export-height=16 >/dev/null 2>&1
    convert "/tmp/${base_name}_16.png" "$output_path/${base_name}_16x16.xpm"

    # Clean up temporary PNGs
    rm "/tmp/${base_name}_32.png" "/tmp/${base_name}_16.png"
done

echo "Conversion complete. XPM files are in $output_dir"

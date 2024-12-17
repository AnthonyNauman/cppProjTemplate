#!/bin/bash

source_folder=$(pwd)/apps/

find "$source_folder" -type f \( -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" \) | while read -r file; do
    clang-format -i "$file"
    echo "Formatted: $file"
done

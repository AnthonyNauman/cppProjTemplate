#!/bin/bash

source $(dirname $0)/project_info.sh

find "$APPS_DIR" -type f \( -name "*.c" -o -name "*.cpp" -o -name "*.h" -o -name "*.hpp" \) | while read -r file; do
    clang-format -i "$file"
    echo "Formatted: $file"
done

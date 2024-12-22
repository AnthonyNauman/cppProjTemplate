#!/bin/bash
source $(dirname $0)/project_info.sh

# Чтение файла построчно
while IFS= read -r line; do
	if [[ "$line" == *"tests"* ]]; then
        $SCRIPTS_DIR/run.sh "$line"
    fi
done < "$UTILS_DIR/run/options"

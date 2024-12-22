#!/bin/bash
source $(dirname $0)/project_info.sh


# Папка, которую нужно просмотреть
directory="$INSTALL_DIR/tests"

report_folder="$UTILS_DIR/test_results"
mkdir -p $report_folder

# Рекурсивный поиск исполняемых файлов и их запуск
find "$directory" -type f -exec chmod +x {} \; -exec {} --gtest_output=xml:$report_folder/xunit.xml \;
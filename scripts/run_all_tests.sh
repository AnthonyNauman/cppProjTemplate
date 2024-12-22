#!/bin/bash
source $(dirname $0)/project_info.sh


# Папка, которую нужно просмотреть
directory="$INSTALL_DIR/tests"

# Рекурсивный поиск исполняемых файлов и их запуск
find "$directory" -type f -exec chmod +x {} \; -exec {} \;
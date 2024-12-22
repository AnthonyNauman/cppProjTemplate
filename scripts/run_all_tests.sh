#!/bin/bash

# Папка, которую нужно просмотреть
directory="./../tests/"

# Рекурсивный поиск исполняемых файлов и их запуск
find "$directory" -type f -exec chmod +x {} \; -exec {} \;
#!/bin/bash

# Проверяем, что переданы аргументы
if [ $# -lt 2 ]; then
    echo "Usage: $0 COMMAND PARAMETER_NAME [VALUE] [FILE_MASK ...]"
    echo  COMMAND:  'add' / 'remove' / 'update'
    exit 1
fi

command="$1"
param="$2"
shift 2

# Обработка команды "add" или "update"
if [ "$command" = "add" ] || [ "$command" = "update" ]; then
    if [ $# -lt 2 ]; then
        echo "Usage: $0 add|update PARAMETER_NAME VALUE FILE_MASK [FILE_MASK ...]"
        exit 1
    fi
    new_value="$1"
    shift

    for file_mask in "$@"; do
        files=($(ls $file_mask 2>/dev/null))
        if [ ${#files[@]} -eq 0 ]; then
            echo "Error: No files found matching $file_mask"
        else
            for file in "${files[@]}"; do
                # Проверяем, что файл существует
                if [ ! -f "$file" ]; then
                    echo "Error: File $file not found"
                else
                    # Проверяем, что параметр существует в файле
                    if grep -q "^$param=" "$file"; then
                        # Обновляем значение параметра в файле
                        sed -i "s/^$param=.*/$param=$new_value/" "$file"
                        echo "Parameter $param updated in $file"
                    else
                        # Добавляем параметр и его значение в файл
                        echo "$param=$new_value" >> "$file"
                        echo "Parameter $param added to $file"
                    fi
                fi
            done
        fi
    done

# Обработка команды "remove"
elif [ "$command" = "remove" ]; then
    for file_mask in "$@"; do
        files=($(ls $file_mask 2>/dev/null))
        if [ ${#files[@]} -eq 0 ]; then
            echo "Error: No files found matching $file_mask"
        else
            for file in "${files[@]}"; do
                # Проверяем, что файл существует
                if [ ! -f "$file" ]; then
                    echo "Error: File $file not found"
                else
                    # Проверяем, что параметр существует в файле
                    if grep -q "^$param=" "$file"; then
                        # Удаляем параметр и его значение из файла
                        sed -i "/^$param=/d" "$file"
                        echo "Parameter $param removed from $file"
                    else
                        echo "Parameter $param not found in $file"
                    fi
                fi
            done
        fi
    done

else
    echo "Invalid command. Use 'add', 'remove', or 'update'."
    exit 1
fi

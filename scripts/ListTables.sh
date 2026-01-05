#!/bin/bash

dbname=$1

echo "-------- List Tables in '$dbname' --------"

db_path="../Databases/$dbname"

if [ ! -d "$db_path" ]; then
    echo "Error: Database '$dbname' not found."
    exit 1
fi

if [ -z "$(ls -A "$db_path")" ]; then
    echo "No tables found in '$dbname'."
else
    ls -1 "$db_path" | grep -v ".meta$" | nl -w2 -s") "
fi
echo "------------------------------------------"

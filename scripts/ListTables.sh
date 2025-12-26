#!/bin/bash

dbname=$1

echo "-------- List Tables in '$dbname' --------"

# 1. Path Strategy (Matches your Create Script)
db_path="../Databases/$dbname"

# 2. Check if Database Directory Exists
if [ ! -d "$db_path" ]; then
    echo "Error: Database '$dbname' not found."
    exit 1
fi

# 3. Check if Database is Empty
if [ -z "$(ls -A "$db_path")" ]; then
    echo "No tables found in '$dbname'."
else
    # 4. List and Filter
    # We list files, hide .meta files, and number the output
    ls -1 "$db_path" | grep -v ".meta$" | nl -w2 -s") "
fi

echo "------------------------------------------"

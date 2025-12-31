#!/bin/bash

dbname=$1

if [ -z "$dbname" ]; then
    echo "Error: Database name missing."
    return
fi

echo "-------- Insert into Table in '$dbname' --------"

echo "Available Tables:"
ls -1 "../Databases/$dbname" | grep -v ".meta"

if [ -z "$(ls -A "../Databases/$dbname")" ]; then
    echo "No tables found."
    sleep 2
    return
fi

echo ""
read -p "Enter table name: " tableName

dbPath="../Databases/$dbname/$tableName"
metaPath="../Databases/$dbname/$tableName.meta"

if [[ -z "$tableName" || ! -f "$dbPath" ]]; then
    echo "Error: Table '$tableName' does not exist."
    sleep 2
    return
fi

#(Format: colName:colType:isPK|colName:colType:isPK)
metaData=$(cat "$metaPath")

IFS='|' read -r -a columnsArray <<< "$metaData"

row=""
colIndex=1

for colDef in "${columnsArray[@]}"; do
    colName=$(echo $colDef | cut -d: -f1)
    colType=$(echo $colDef | cut -d: -f2)
    isPK=$(echo $colDef | cut -d: -f3)

    echo ""
    echo "Enter value for column: $colName ($colType)"
    if [[ "$isPK" == "yes" ]]; then echo "(Primary Key)"; fi

    while true; do
        read -p "Value: " val

        #Check Type:
        if [[ "$colType" == "int" ]]; then
            if [[ ! "$val" =~ ^[0-9]+$ ]]; then
                echo "Error: '$colName' must be an integer."
                continue
            fi
        fi
                if [[ "$colType" == "string" ]]; then
      if [[ ! "$val" =~ ^[a-zA-Z\ _]+$ ]]; then
                echo "Error: '$colName' must be an string."
                continue
            fi
        fi 
        
        #Check Primary Key:
        if [[ "$isPK" == "yes" ]]; then
            if [ -s "$dbPath" ]; then
                if awk -F: -v col="$colIndex" -v val="$val" '$col == val {found=1} END {if (found) exit 0; else exit 1}' "$dbPath"; then
                    echo "Error: Primary Key '$val' already exists."
                    continue
                fi
            fi
        fi

        break
    done

    if [[ "$row" == "" ]]; then
        row="$val"
    else
        row="$row:$val"
    fi

    ((colIndex++))
done

echo "$row" >> "$dbPath"
sleep 1
echo ""
echo "Row inserted successfully!"
sleep 1
echo "--- New Inserted Row ---"
sed -n '$p' "$dbPath"

sleep 3

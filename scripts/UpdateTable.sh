#!/bin/bash

dbname=$1

if [ -z "$dbname" ]; then
    echo "Error: Database name missing."
    sleep 2
    return
fi
echo ""
echo "-------- Update Table in '$dbname' --------"

# List Tables
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

#read metaddata
metaData=$(cat "$metaPath")
IFS='|' read -r -a columnsArray <<< "$metaData"

#-------------------- Functions -----------------------
# Get column index by name
get_col_index() {
    local name="$1"
    local i=1
    for colDef in "${columnsArray[@]}"; do
        colName=$(echo "$colDef" | cut -d: -f1)
        if [[ "$colName" == "$name" ]]; then
            echo "$i"
            return
        fi
        ((i++))
    done
}

# Get column type by name
get_col_type() {
    local name="$1"
    for colDef in "${columnsArray[@]}"; do
        colName=$(echo "$colDef" | cut -d: -f1)
        colType=$(echo "$colDef" | cut -d: -f2)
        if [[ "$colName" == "$name" ]]; then
            echo "$colType"
            return
        fi
    done
}
#display cols of table
display_columns() {
    echo ""
    echo "Available Columns:"
    local i=1
    for colDef in "${columnsArray[@]}"; do
        colName=$(echo "$colDef" | cut -d: -f1)
        echo "$colName"
        ((i++))
    done
    echo ""
}
is_primary_key() {
    local col="$1"

    for colDef in "${columnsArray[@]}"; do
        colName=$(cut -d: -f1 <<< "$colDef")
        isPK=$(cut -d: -f3 <<< "$colDef")

        if [[ "$colName" == "$col" && "$isPK" == "yes" ]]; then
            return 0  
        fi
    done

    return 1 
}

# ---------------- Choose column to update ----------------
display_columns
read -p "Enter column name to update: " setCol
setIndex=$(get_col_index "$setCol")
setType=$(get_col_type "$setCol")

if [ -z "$setIndex" ]; then
    echo "Error: Invalid column name."
    sleep 2
    return
fi

read -p "Enter new value: " newVal

# Validate new value type
if [[ "$setType" == "int" ]]; then
    if [[ ! "$newVal" =~ ^[0-9]+$ ]]; then
        echo "Error: '$setCol' must be an integer."
        sleep 2
        return
    fi
fi

if [[ "$setType" == "string" ]]; then
    if [[ ! "$newVal" =~ ^[a-zA-Z\ ]+$ ]]; then
        echo "Error: '$setCol' must be a string."
        sleep 2
        return
    fi
fi

echo ""
echo "1) Update ALL rows"
echo "2) Update with condition (WHERE)"
read -p "Choose option: " opt

# ---------------- UPDATE ALL ----------------
if [[ "$opt" == "1" ]]; then

    if is_primary_key "$setCol"; then
        echo "Error: Cannot update ALL rows on a Primary Key column."
        sleep 2
        return
    fi

    awk -F':' -v OFS=':' -v col="$setIndex" -v val="$newVal" '
    {
        $col = val
        print
    }
    ' "$dbPath" > "$dbPath.tmp"


# ---------------- UPDATE WITH CONDITION ----------------
elif [[ "$opt" == "2" ]]; then
    display_columns
    read -p "Enter condition column: " condCol
    condIndex=$(get_col_index "$condCol")
    condType=$(get_col_type "$condCol")

    if [ -z "$condIndex" ]; then
        echo "Error: Invalid condition column."
        sleep 2
        return
    fi

    read -p "Enter condition value: " condVal

    if is_primary_key "$setCol"; then
        pk_count=$(awk -F':' -v c="$setIndex" -v v="$newVal" '
            $c == v { count++ }
            END { print count+0 }
        ' "$dbPath")

        if [ "$pk_count" -ge 1 ]; then
            echo "Duplicate PK, Update failed"
            sleep 2
            return
        fi
    fi


    # Validate condition value 
    if [[ "$condType" == "int" ]]; then
        if [[ ! "$condVal" =~ ^[0-9]+$ ]]; then
            echo "Error: '$condCol' must be an integer."
            sleep 2
            return
        fi

        awk -F':' -v OFS=':' \
            -v s="$setIndex" -v v="$newVal" \
            -v c="$condIndex" -v cv="$condVal" '
        {
            if ($c + 0 == cv + 0)
                $s = v
            print
        }
        ' "$dbPath" > "$dbPath.tmp"

    else
        if [[ ! "$condVal" =~ ^[a-zA-Z\ ]+$ ]]; then
            echo "Error: '$condCol' must be a string."
            sleep 2
            return
        fi

        awk -F':' -v OFS=':' \
            -v s="$setIndex" -v v="$newVal" \
            -v c="$condIndex" -v cv="$condVal" '
        {
            if ($c == cv)
                $s = v
            print
        }
        ' "$dbPath" > "$dbPath.tmp"
    fi

else
    echo "Invalid option."
    sleep 2
    return
fi

mv "$dbPath.tmp" "$dbPath"
echo ""
echo "Update completed successfully."
sleep 2

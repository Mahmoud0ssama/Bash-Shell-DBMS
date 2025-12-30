#!/bin/bash

dbname=$1

echo "-------- Create Table in '$dbname' --------"

while true; do
    echo ""
    read -p "Enter table name (or 'exit' to return): " tablename

    if [[ "$tablename" == "exit" ]]; then
        return 
    fi

    # Validation
    if [[ -z "$tablename" || ! "$tablename" =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Error: Invalid name."
        continue
    fi

    # We are in scripts, so DBs are in ../Databases
    if [ -f "../Databases/$dbname/$tablename" ]; then
        echo "Error: Table '$tablename' already exists."
        continue
    fi

    read -p "Enter number of columns: " col_count
    if [[ ! "$col_count" =~ ^[1-9][0-9]*$ ]]; then
        echo "Error: Invalid number."
        continue
    fi

    metaData=""     #Initializes an empty string variable
    hasPK="no"

    for ((i=1; i<=col_count; i++)); do
        echo "--- Column $i ---"
        
       # Name
        while true; do
            read -p "Enter Name: " colName
            if [[ "$colName" =~ ^[a-zA-Z_]+$ ]]; then
                 break
            else
                 echo "Invalid name"
                 fi
        done
        
        # Type
        while true; do
            read -p "Enter Type (int/string): " colType
            if [[ "$colType" == "int" || "$colType" == "string" ]]; then break; fi
            echo "Invalid type."
        done

        # PK
        isPK="no"
        if [[ "$hasPK" == "no" ]]; then
            read -p "Primary Key? (y/n): " pkChoice
            [[ "$pkChoice" =~ [yY] ]] && isPK="yes" && hasPK="yes"
        fi

        sep="|"
        if [[ $i -eq $col_count ]]; then sep=""; fi
        metaData+="$colName:$colType:$isPK$sep"
    done

    if [[ "$hasPK" == "no" ]]; then
        echo "Error: Must have Primary Key."
    else
        touch "../Databases/$dbname/$tablename"
        echo "$metaData" > "../Databases/$dbname/$tablename.meta"
        echo "Table '$tablename' created successfully."
    fi
done

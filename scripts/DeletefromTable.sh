#!/bin/bash

dbname=$1

echo "-------- Delete Menu for '$dbname' --------"
echo "Available Tables:"
ls -1 "../Databases/$dbname" | grep -v ".meta"

if [ -z "$(ls -A "../Databases/$dbname")" ]; then
    echo "No tables found."
    sleep 2
    return
fi

echo ""
read -p "Enter Table name: " tableName

dbPath="../Databases/$dbname/$tableName"
metaPath="../Databases/$dbname/$tableName.meta"

if [[ -z "$tableName" || ! -f "$dbPath" ]]; then
    echo "Error: Table '$tableName' does not exist."
    sleep 1
    return
fi

metaData=$(cat "$metaPath")   #Read Schema
IFS='|' read -r -a columnsArray <<< "$metaData"
numColumns=${#columnsArray[@]}

while true; do
    echo "-------- Delete Options for Table: $tableName --------"
    echo "1. Delete specific Row (by Primary Key)"
    echo "2. Delete specific Column"
    echo "3. Delete ALL Data (Empty Table)"
    echo "4. Back to Database Menu"
    echo ""
    read -p "Choose an option: " op

    case $op in
        1) 
            #CASE 1: Delete Row by PK 
            
            pkColIndex=0
            pkColName=""
            currIndex=1
            for colDef in "${columnsArray[@]}"; do
                colName=$(echo $colDef | cut -d: -f1)  
                isPK=$(echo $colDef | cut -d: -f3)    
                if [[ "$isPK" == "yes" ]]; then
                    pkColIndex=$currIndex
                    pkColName=$colName
                    break
                fi
                ((currIndex++))
            done

            echo "Primary Key Column: $pkColName"
            read -p "Enter Value of '$pkColName' to delete: " pkValue

            if [ -z "$pkValue" ]; then
                echo "Error: Value cannot be empty."
                sleep 1
                continue
            fi

            # Check if record exists
            found=$(awk -F: -v col="$pkColIndex" -v val="$pkValue" '$col == val {print "yes"}' "$dbPath")
            
            if [[ "$found" != "yes" ]]; then
                echo "Error: Record with ID '$pkValue' not found."
            else
                tempFile="${dbPath}_temp"
                awk -F: -v col="$pkColIndex" -v val="$pkValue" '$col != val' "$dbPath" > "$tempFile"
                mv "$tempFile" "$dbPath"
                echo "Record deleted successfully."
            fi
            sleep 2
            ;;

        2) 
            #CASE 2: Delete Column
            
            echo "--- Current Columns ---"
            idx=1
            for colDef in "${columnsArray[@]}"; do
                cName=$(echo $colDef | cut -d: -f1)
                cPK=$(echo $colDef | cut -d: -f3)
                echo "$idx) $cName (PK: $cPK)"
                ((idx++))
            done

            read -p "Enter Column NAME to delete: " colToDelete
            
            # Find Index of column to delete
            delIndex=0
            loopIndex=1
            isTargetPK="no"

            for colDef in "${columnsArray[@]}"; do
                cName=$(echo $colDef | cut -d: -f1)
                cPK=$(echo $colDef | cut -d: -f3)
                
                if [[ "$cName" == "$colToDelete" ]]; then
                    delIndex=$loopIndex
                    isTargetPK=$cPK
                    break
                fi
                ((loopIndex++))
            done

            # Validation
            if [[ $delIndex -eq 0 ]]; then
                echo "Error: Column '$colToDelete' not found."
                sleep 1
                continue
            fi

            if [[ "$isTargetPK" == "yes" ]]; then
                echo "Error: Cannot delete the Primary Key column!"
                sleep 2
                continue
            fi

            read -p "Are you sure you want to delete column '$colToDelete'? (y/n): " confirm
            if [[ "$confirm" != "y" ]]; then continue; fi

            #We keep fields 1-(N-1) and (N+1)-End 
            tempFile="${dbPath}_temp"
            
            if [[ $delIndex -eq 1 ]]; then
                # Delete first column -> keep 2-end
                cut -d: -f2- "$dbPath" > "$tempFile"
            elif [[ $delIndex -eq $numColumns ]]; then
                # Delete last column -> keep 1-(end-1)
                cut -d: -f1-$((numColumns-1)) "$dbPath" > "$tempFile"
            else
                # Delete middle column -> keep 1-(idx-1) AND (idx+1)-end
                cut -d: -f1-$((delIndex-1)),$((delIndex+1))- "$dbPath" > "$tempFile"
            fi
            
            mv "$tempFile" "$dbPath"

            #Update Metadata File
            newMeta=""
            sep=""
            for colDef in "${columnsArray[@]}"; do
                cName=$(echo $colDef | cut -d: -f1)
                if [[ "$cName" != "$colToDelete" ]]; then
                    newMeta+="$sep$colDef"
                    sep="|"
                fi
            done
            
            echo "$newMeta" > "$metaPath"
            
            IFS='|' read -r -a columnsArray <<< "$newMeta"
            numColumns=${#columnsArray[@]}

            echo " Column '$colToDelete' deleted successfully."
            sleep 2
            ;;

        3) 
            #CASE 3: Delete All Data
            read -p "WARNING: This will empty the table. Are you sure? (y/n): " confirm
            if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                > "$dbPath"
                echo " All data deleted. Table structure remains."
            else
                echo "Cancelled."
            fi
            sleep 1
            ;;

        4) 
            return 
            ;;

        *) 
            echo "Invalid option." 
            sleep 1
            ;;
    esac
done

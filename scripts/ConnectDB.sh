#!/bin/bash

dbName=$1

# Safety check: Ensure database name was passed
if [ -z "$dbName" ]; then
    echo "Error: Database name lost. returning..."
    return
fi

while true; do
    clear 
    
    echo -e "======== Menu for Database: $dbName ========
    \n1. Create Table\n2. List Tables\n3. Drop Table\n4. Insert into Table\n5. Select From Table\n6. Delete From Table\n7. Update Table\n8. Back to Main Menu\n"
    
    read -p "Choose an option: " choice

    case "$choice" in
        1)
            if [ -x "./CreateTable.sh" ]; then
                source ./CreateTable.sh "$dbName"
            else
                echo "Error: CreateTable.sh not found."
                sleep 1
            fi
            ;;
        2) 
			source ./ListTables.sh "$dbName" 
			echo ""
			read -p "Press Enter to return to menu..."
			;;
        3) 
			source ./DropTable.sh "$dbName"
			;;
        4) 
			source ./InsertintoTable.sh "$dbName" 
			;;
        5) 
			source ./SelectfromTable.sh "$dbName" 
			;;
        6) 
			source ./DeletefromTable.sh "$dbName" 
			;;
        7) 
			source ./UpdateTable.sh "$dbName" 
			;;
        8) 
            echo "Returning to Main Menu..."
            break 
            ;;
        *) 
			echo "Invalid Option" 
			;;
    esac
done


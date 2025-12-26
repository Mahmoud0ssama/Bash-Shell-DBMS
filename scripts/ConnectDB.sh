<<<<<<< HEAD
#!/bin/bash

dbName=$1

# Safety check: Ensure database name was passed
if [ -z "$dbName" ]; then
    echo "Error: Database name lost. returning..."
    return
fi

while true; do
    # Clear screen so the menu appears alone
    clear 
    
    # -e enables interpretation of backslash escapes like \n
    echo -e "======== Menu for Database: $dbName ========
    \n1. Create Table\n2. List Tables\n3. Drop Table\n4. Insert into Table\n5. Select From Table\n6. Delete From Table\n7. Update Table\n8. Back to Main Menu\n"
    
    read -p "Choose an option: " choice

    case "$choice" in
        1)  # Create Table
            if [ -f "./CreateTable.sh" ]; then
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
        3) source ./DropTable.sh "$dbName" ;;
        4) source ./InsertintoTable.sh "$dbName" ;;
        5) source ./SelectfromTable.sh "$dbName" ;;
        6) source ./DeletefromTable.sh "$dbName" ;;
        7) source ./UpdateTable.sh "$dbName" ;;
        8) 
            echo "Returning to Main Menu..."
            break 
            ;;
        *) echo "Invalid Option" ;;
    esac
done
=======
#!/bin/bash 

clear
echo "Connected database is: $db"

Script_Path="../../scripts"

PS3="Choose an option: "
select choice in \
	"Create Table" \
       	"List Tables" \
	"Drop Table" \
	"Insert into Table" \
	"Select From Table" \
	"Delete From Table" \
	"Update table" \
	"Exit"
do
	case "$REPLY" in 
		1)
			"$Script_Path/CreateTable.sh"
			;;
		
		2)
			"$Script_Path/ListTables.sh"
			;;

		3)
			"$Script_Path/DropTable.sh"
			;;

		4)
			"$Script_Path/InsertintoTable.sh"
			;;

		5)
			"$Script_Path/SelectfromTable.sh"
			;;

		6)
			"$Script_Path/DeletefromTable.sh"
			;;

		7)
			"$Script_Path/UpdateTable.sh"
			;;

		8)
			break
			;;

		*)
			echo "Invalid choice"
			;;

	esac
done	
>>>>>>> 3433acf0cd2289147d91af4387c82a038a7d335e

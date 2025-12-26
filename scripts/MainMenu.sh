#!/bin/bash

echo "======== Main menu =========="

PS3="Choose an option:"

while true; do
    # This prints every option on a new line clearly
    echo -e "\n1. Create Database\n2. List Databases\n3. Connect To Database\n4. Drop Database\n5. Exit"
    
    read -p "Enter your choice: " choice

#COLUMNS=1 select choice in "Create Database" "List Databases" "Connect databases" "Drop database" "Exit"
	
    case "$choice" in
        1)  #Create Database
            read -p "Enter database name: " db
	    #-z checks if string length is zero
	    if [ -z "$db" ]; then
                echo "Database name cannot be empty"
                continue
            fi
            #Hides “File exists” error and echo created if succeed or exist if failed to create
	    mkdir ../Databases/"$db" 2>/dev/null && echo "Database created" || echo "Database already exists" 
	    sleep 1
	    ;;
     
  2)  #List Databases
        if [ -d "../Databases" ] && [ "$(ls -A ../Databases)" ]; then
            echo "Databases List:"
            # ls gets names | sed adds ' DB' to the end | nl adds numbers
            ls ../Databases | sed 's/$/ DB/' | nl -w 2 -s ') '
        else
            echo "No databases found"
        fi
        sleep 1
        ;;
       3)  # Connect To Database
            read -p "Enter database name to connect: " db
            
            # Check if it exists in the parallel folder
            if [ -d "../Databases/$db" ]; then
                echo "Connected to $db"
<<<<<<< HEAD
                sleep 1
                clear
                # Call the connect script from CURRENT folder
               if [ -f "./ConnectDB.sh" ]; then
                   source ./ConnectDB.sh "$db"
                fi
=======
                export db
		../../scripts/ConnectDB.sh
		exit
>>>>>>> 3433acf0cd2289147d91af4387c82a038a7d335e
            else
                echo "Error: Database '$db' not found."
            fi
            ;;
        4)  #Drop database
            read -p "Enter database name to drop: " db
            if [ -z "$db" ]; then
                echo "Database name cannot be empty"
                continue
            fi

	    read -p "Are you sure you want to drop '$db'? (y/n): " confirm
            case "$confirm" in
       	    y|Y)
           	 rm -r ../Databases/"$db" 2>/dev/null && echo "Database dropped" || echo "Database not found"
            	 ;;
            *)
            	 echo "Drop cancelled"
            	 ;;
    	    esac
	    ;;
        5)  #Exit
            echo "Exiting..."
            exit
            ;;
        *)
            echo "Invalid choice"
            ;;
    esac
done


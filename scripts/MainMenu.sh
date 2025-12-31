#!/bin/bash

while true; do
    echo "======== Main menu =========="
    echo -e "1. Create Database\n2. List Databases\n3. Connect To Database\n4. Drop Database\n5. Exit"
    
    read -p "Enter your choice: " choice

    case "$choice" in
        1)  #Create Database 
            read -p "Enter database name: " db
	        if [ -z "$db" ]; then
                echo "Database name cannot be empty"
                continue
            fi
            if [[ ! "$db" =~ ^[a-zA-Z_]+$ ]]; then
                echo "Error Database name: must be a string "
                continue
            fi
            
	        mkdir ../Databases/"$db" 2>/dev/null && echo "Database created" || echo "Database already exists" 
	        sleep 1
	        ;;
     
        2)  #List Databases
            if [ -d "../Databases" ] && [ "$(ls -A ../Databases)" ]; then
                clear
                echo "Databases List:"
                ls ../Databases | sed 's/$/ DB/' | nl -w 2 -s ') '
            else
                echo "No databases found"
            fi
            sleep 1
            ;;

       3)  # Connect To Database
            read -p "Enter database name to connect: " db
            
            if [ -d "../Databases/$db" ]; then
                echo "Connected to $db"
                sleep 1
                clear

                if [ -f "./ConnectDB.sh" ]; then
                   source ./ConnectDB.sh "$db"
                   #export db
                fi

            else
                echo "Error: Database '$db' not found."
            fi
            ;;

        4)  # Drop database
            read -p "Enter database name to drop: " db
            if [ -z "$db" ]; then
                echo "Database name cannot be empty"
                continue
            fi

            if [ ! -d "../Databases/$db" ]; then
                echo "Database not found"
                continue
            fi

            read -p "Are you sure you want to drop '$db'? (y/n): " confirm
            case "$confirm" in
                y|Y)
                rm -r "../Databases/$db" 2>/dev/null && echo "Database dropped" || echo "Failed to drop database"
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


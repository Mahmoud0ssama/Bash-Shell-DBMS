#!/bin/bash

echo "======== Main menu =========="

PS3="Choose an option:"
select choice in "Create Database" "List Databases" "Connect database" "Drop database" "Exit"
do	
    case "$REPLY" in
        1)  #Create Database
            read -p "Enter database name: " db
	    #-z checks if string length is zero
	    if [ -z "$db" ]; then
                echo "Database name cannot be empty"
                continue
            fi
            #Hides “File exists” error and echo created if succeed or exist if failed to create
	    mkdir ../Databases/"$db" 2>/dev/null && echo "Database created" || echo "Database already exists"
            ;;
        2)  #List Databases
            echo "Databases:"
            ls -d ../Databases/* 2>/dev/null || echo "No databases found"
            ;;
        3)  #Connect database
            read -p "Enter database name to connect: " db
            if [ -z "$db" ]; then
                echo "Database name cannot be empty"
                continue
            fi
	    if [ -d ../Databases/"$db" ]; then
                cd ../Databases/"$db" || exit
                echo "Connected to $db"
		../../scripts/connectDB.sh
		exit
            else
                echo "Database not found"
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


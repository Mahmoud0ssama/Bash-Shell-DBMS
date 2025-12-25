#!/bin/bash

echo "======== Main menu =========="
PS3="Choose an option:"
select choice in "Create Database" "List Databases" "Connect database" "Drop database" "Exit" 
do
    case "$REPLY" in
        1)
            read -p "Enter database name: " db
            #Hides “File exists” error and echo created if succeed or exist if failed to create
	    mkdir ../Databases/"$db" 2>/dev/null && echo "Database created" || echo "Database already exists"
            ;;
        2)
            echo "Databases:"
            ls -d ../Databases/* 2>/dev/null || echo "No databases found"
            ;;
        3)
            read -p "Enter database name to connect: " db
            if [ -d "$db" ]; then
                cd "$db" || exit
                echo "Connected to $db"
            else
                echo "Database not found"
            fi
            ;;
        4)
            read -p "Enter database name to drop: " db
            rm -r ../Databases/"$db" 2>/dev/null && echo "Database dropped" || echo "Database not found"
            ;;
        5)
            echo "Exiting..."
            exit
            ;;
        *)
            echo "Invalid choice"
            ;;
    esac
done


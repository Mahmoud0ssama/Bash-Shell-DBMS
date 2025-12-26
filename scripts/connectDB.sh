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

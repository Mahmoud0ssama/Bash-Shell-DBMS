#!/bin/bash 

echo "Connected database is: $db"

clear
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
			./CreateTable.sh
			;;
		
		2)
			./ListTables.sh
			;;

		3)
			./DropTable.sh
			;;

		4)
			./InsertintoTable.sh
			;;

		5)
			./SelectfromTable.sh
			;;

		6)
			./DeletefromTable.sh
			;;

		7)
			./UpdateTable.sh
			;;

		8)
			break
			;;

		*)
			echo "Invalid choice"
			;;

	esac
done	

#!/bin/bash

Path_to_DB="../Databases/$db"

read -p "Enter Table name to drop: " Table 
    if [ -z "$Table" ]; then
        echo "Table name cannot be empty"
        exit 1
    fi

read -p "Are you sure you want to drop '$Table'? (y/n): " confirm
    case "$confirm" in
  	    y|Y)
  	        rm  "Path_to_DB/$Table" 2>/dev/null && echo "Table dropped" || echo "Table not found"
	        ;;

        *)
            echo "Drop cancelled"
            ;;
    esac
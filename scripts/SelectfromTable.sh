#!/bin/bash

db="$1"
DB_PATH="../Databases/$db"

read -p "Enter table name: " table

TABLE_FILE="$DB_PATH/$table"
META_FILE="$DB_PATH/$table.meta"

# ---------------- Validation ----------------
if [ ! -f "$TABLE_FILE" ] || [ ! -f "$META_FILE" ]; then
    echo "Error: Table does not exist"
    exit 1
fi

#meta_file style -> columnName:columnType:isPrimaryKey | ...
#split on | or : , print fields 1,4,7, ...
# ---------------- Get column number ----------------
get_col_num() {
    awk -F'[|:]' -v col="$1" '
    {
        for (i=1;i<=NF;i+=3)
            if ($i==col) print (i+2)/3      #make numbers 1,2,3,..
    }' "$META_FILE"
}

#convert column names into column numbers as awk works with nums not names
# ---------------- Get multiple columns ----------------
get_cols() {
    IFS=',' read -ra arr <<< "$1"
    nums=""

    for c in "${arr[@]}"; do
        n=$(get_col_num "$c")
        #check if column exist
        [ -z "$n" ] && return 1
        #Appends number + comma
        nums+="$n,"
    done
    #remove last comma
    echo "${nums%,}"
}

# ---------------- Condition menu ----------------
condition_menu() {
    read -p "Enter condition column: " cond_col
    read -p "Enter value: " cond_val

    cond_num=$(get_col_num "$cond_col")
    [ -z "$cond_num" ] && return 1
}
# ---------------- Print all header ----------------
print_header() {
    cols=$(awk -F'[|:]' '{ for(i=1;i<=NF;i+=3) printf "%d,", (i+2)/3 }' "$META_FILE")
    cols="${cols%,}"
}
# ---------------- Print headers + data ----------------
#print_data "2,3" 1 5 
#equivalent to
#SELECT col2,col3 WHERE col1 = 5
print_data() {
    awk -F'|' -v cols="$1" -v k="$2" -v v="$3" '
    BEGIN {
        split(cols, c, ",")  
    }
    #-------- Build the header -----------
    #NR: global record number -> counts all lines across all input files
    #FNR: record number ->  counts lines in current file 
    NR==FNR {
        split($0, meta, "[|:]")     #meta has all field names
        for (i=1;i<=length(c);i++)
            #(c[i]-1)*3 + 1 -> col num to metadata field index
            #header = meta[field index]
            headers[i] = meta[(c[i]-1)*3 + 1]
        next    #move to next line -> next file(Table)
    }
    #--------- print the header -----------
    NR==2 {
        for (i=1;i<=length(headers);i++)
            printf "%s\t\t", headers[i]
        print ""    #\n
    }
    #where condition
    #$k value of column k in current row
    #k=="" -> no condition
    #$k==v  -> $k = value from user
    (k=="" || $k==v) {
        for (i=1;i<=length(c);i++)
            printf "%s\t\t", $c[i]
        print ""
    }
    ' "$META_FILE" "$TABLE_FILE"
}

# ================= SELECT MENU =================
while true; do
    echo
    echo "========= SELECT MENU ========="
    echo "1) Select ALL"
    echo "2) Select * with condition"
    echo "3) Select column"
    echo "4) Select MULTIPLE columns"
    echo "5) Exit"
    read -p "Choose option: " choice

    case "$choice" in

    # -------- SELECT ALL --------
    1)
        print_header
        print_data "$cols"
        ;;

    # -------- SELECT * WHERE --------
    2)
        condition_menu || { echo "Invalid condition"; continue; }
        print_header
        print_data "$cols" "$cond_num" "$cond_val"
        ;;

    # -------- SELECT ONE COLUMN --------
    3)
        read -p "Enter column name: " col
        col_num=$(get_col_num "$col")
        [ -z "$col_num" ] && { echo "Invalid column"; continue; }

        echo "1) Without condition"
        echo "2) With condition"
        read -p "Choose: " opt

        if [ "$opt" == "1" ]; then
            print_data "$col_num"
        elif [ "$opt" == "2" ]; then
            condition_menu || { echo "Invalid condition"; continue; }
            print_data "$col_num" "$cond_num" "$cond_val"
        else
            echo "Invalid option"
        fi
        ;;

    # -------- SELECT MULTIPLE COLUMNS --------
    4)
        read -p "Enter column names (comma separated): " cols
        col_nums=$(get_multi_cols "$cols") || { echo "Invalid column"; continue; }

        echo "1) Without condition"
        echo "2) With condition"
        read -p "Choose: " opt

        if [ "$opt" == "1" ]; then
            print_data "$col_nums"
        elif [ "$opt" == "2" ]; then
            condition_menu || { echo "Invalid condition"; continue; }
            print_data "$col_nums" "$cond_num" "$cond_val"
        else
            echo "Invalid option"
        fi
        ;;

    # -------- EXIT --------
    5)
        break
        ;;

    *)
        echo "Invalid choice"
        ;;
    esac
done


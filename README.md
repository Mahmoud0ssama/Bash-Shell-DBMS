# Bash DBMS Project

## Overview
This project is a simple Database Management System (DBMS) implemented using **Bash scripting**.  
It simulates basic database functionality using the Linux file system, without using any external database engine.

Each **database** is represented as a directory, and each **table** is represented as a file inside that directory.  
Table metadata (columns, data types, primary key) is stored in a separate `.meta` file.

---

## Features

### Database Operations
- Create database
- List databases
- Connect to database
- Drop database

### Table Operations
- Create table
- List tables
- Drop table
- Insert into table
- Select from table
- Update table
- Delete from table

### Data Integrity
- Supports data types: `int`, `string`
- Supports Primary Key
- Prevents duplicate primary key values
- Prevents updating all rows of a primary key column
- Uses safe updates via temporary files

---


---

## Data Representation

### Metadata File

**Format:**

`column_name:data_type:is_primary_key`

**Example:**
`id:int:yes | name:string:no | course:string:no`


### Table File
- Data is stored in plain text
- Columns are separated by `:`


## Run Steps

1. Open a terminal and navigate to the project directory:
```bash
cd DBMSscript/scripts/
chmod +x *.sh
./MainMenu.sh




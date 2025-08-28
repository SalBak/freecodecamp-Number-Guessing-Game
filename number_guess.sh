#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

random_num=$((RANDOM % 1001))
echo $random_num

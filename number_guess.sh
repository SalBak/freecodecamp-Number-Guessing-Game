#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

random_num=$((RANDOM % 1001))
echo $random_num

echo -e "\nEnter your username:"
read USERNAME

USER_INFO=$($PSQL "SELECT username,games_played,best_game from users where username=$USERNAME")
if [[ -z $USER_INFO ]]
then 
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER=$($PSQL "INSERT INTO users(username,games_played,best_game) values("$USER_INFO",0,NULL);")
else 
  echo "$USER_INFO" | while IFS="|" read USERNAME_DB GAMES_PLAYED BEST_GAME
  do
    if [[ -z $BEST_GAME ]]
    then
      echo "Welcome back, $USERNAME_DB! You have played $GAMES_PLAYED games, and your best game took 0 guesses."
    else
      echo "Welcome back, $USERNAME_DB! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
    fi
  done
fi

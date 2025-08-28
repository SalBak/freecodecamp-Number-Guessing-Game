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

echo "Guess the secret number between 1 and 1000:"
read USER_GUESS

GUESS_COUNT=1
while [[ $USER_GUESS -ne $random_num ]]
do
  if [[ ! $USER_GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  elif [[ $USER_GUESS -gt $random_num ]]
  then
    echo "It's lower than that, guess again:"
  else
    echo "It's higher than that, guess again:"
  fi

  read USER_GUESS
  ((GUESS_COUNT++))
done

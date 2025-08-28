#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

random_num=$((RANDOM % 1001))
echo $random_num

echo -e "\nEnter your username:"
read USERNAME

USER_INFO=$($PSQL "SELECT username,games_played,best_game from users where username='$USERNAME'")
if [[ -z $USER_INFO ]]
then 
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$USERNAME', 0, NULL)")
else 
  IFS="|" read USERNAME_DB GAMES_PLAYED BEST_GAME <<< "$USER_INFO"
  if [[ -z $BEST_GAME ]]
  then
    echo "Welcome back, $USERNAME_DB! You have played $GAMES_PLAYED games, and your best game took 0 guesses."
  else
    echo "Welcome back, $USERNAME_DB! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi
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

echo "You guessed it in $GUESS_COUNT tries. The secret number was $random_num. Nice job!"

UPDATE_USER=$($PSQL "UPDATE users SET games_played = games_played + 1, best_game = CASE WHEN best_game IS NULL OR $GUESS_COUNT < best_game THEN $GUESS_COUNT ELSE best_game END WHERE username='$USERNAME'")

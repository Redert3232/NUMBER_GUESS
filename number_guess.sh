#!/bin/bash


PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\nEnter your username:"

read USERNAME

RANDOM_NUMBER=$(( $RANDOM % 1000 +1))

TABLE=$($PSQL "SELECT * FROM users WHERE username='$USERNAME'")



  if [[ -z $TABLE ]]
  then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
    GAMES_PLAYED=1
  else
    echo "$TABLE"
    GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME'")
    BEST=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME'")
      echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST guesses."
    
  fi

echo -e "\nGuess the secret number between 1 and 1000:"

ATTEMPTS=1





  while read GUESS
  do
     if [[ ! $GUESS =~ ^[0-9]+$ ]]
      then
         echo "That is not an integer, guess again:"
      else

         if [[ $GUESS -eq $RANDOM_NUMBER ]]
         then
          echo "You guessed it in $ATTEMPTS tries. The secret number was $RANDOM_NUMBER. Nice job!"
          break;

         else
            if [[ $GUESS -gt $RANDOM_NUMBER ]]
            then
              echo "It's lower than that, guess again:"
            elif [[ $GUESS -lt $RANDOM_NUMBER ]]
            then
              echo "It's higher than that, guess again:"
            fi
         fi

     fi

  ATTEMPTS=$(( $ATTEMPTS + 1 ))
  done


BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME'")
if [[ -z $BEST_GAME ]]
then
 INSERT_VALUES=$($PSQL "UPDATE users SET games_played=$GAMES_PLAYED, best_game=$ATTEMPTS WHERE username='$USERNAME' ")
else
  if [[ $ATTEMPTS -lt $BEST_GAME ]]
  then
    INSERT_VALUES=$($PSQL "UPDATE users SET games_played=$GAMES_PLAYED, best_game=$ATTEMPTS WHERE username='$USERNAME' ")
  else
    INSERT_VALUES=$($PSQL "UPDATE users SET games_played=$GAMES_PLAYED WHERE username='$USERNAME' ")
  fi
fi
 

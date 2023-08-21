#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "truncate teams, games")"

cat games.csv | while IFS=',' read year round winner opponent winner_goals opponent_goals; do
  
  # skip the column names row
  if [[ $year == 'year' ]]; then 
    continue
  fi

  winner_id=$($PSQL "select team_id from teams where name='$winner'")
  opponent_id=$($PSQL "select team_id from teams where name='$opponent'")
  
  if [[ -z $winner_id ]]; then
    result=$($PSQL "insert into teams(name) values('$winner')")
    if [[ $result == 'INSERT 0 1' ]];then
      winner_id=$($PSQL "select team_id from teams where name='$winner'")
    fi
  fi

  if [[ -z $opponent_id ]]; then
    result=$($PSQL "insert into teams(name) values('$opponent')")
    if [[ $result == 'INSERT 0 1' ]];then
      opponent_id=$($PSQL "select team_id from teams where name='$opponent'")
    fi
  fi

  result=$($PSQL "insert into games(year,round,winner_id,opponent_id,opponent_goals,winner_goals) values('$year','$round','$winner_id','$opponent_id','$opponent_goals','$winner_goals')")
  echo $result

  done
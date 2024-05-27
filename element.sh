#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"

#check if argument exists
if [[ $1 ]]
then
  #if argument exists, check if argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    #if argument is a number, do select query searching for atomic number
    ELEMENT=$($PSQL "SELECT elements.atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements
      LEFT JOIN properties ON elements.atomic_number = properties.atomic_number
      LEFT JOIN types ON properties.type_id = types.type_id
      WHERE elements.atomic_number = '$1'")
    #check if query returned anything
    if [[ -z $ELEMENT ]]
    then
      #if query is empty, output error message
      echo "I could not find that element in the database."
    else
      #if query is not empty, output the information
      echo $ELEMENT | while read NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELT BAR BOIL BAR TYPE
      do
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
      done
    fi
  else
    #if argument is not a number, do select query searching for element symbol or name
    ELEMENT=$($PSQL "SELECT elements.atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements
      LEFT JOIN properties ON elements.atomic_number = properties.atomic_number
      LEFT JOIN types ON properties.type_id = types.type_id
      WHERE symbol = '$1' OR name = '$1'")
      if [[ -z $ELEMENT ]]
      then
        #if query is empty, output error message
        echo "I could not find that element in the database."
      else
        #if query is not empty, output the information
        echo $ELEMENT | while read NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELT BAR BOIL BAR TYPE
        do
          echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
        done
      fi
  fi
else
  #if argument does not exist, output error message
  echo "Please provide an element as an argument."
fi
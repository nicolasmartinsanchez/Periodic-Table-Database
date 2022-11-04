#! /bin/bash 
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"


if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where atomic_number=$1")
    ELEMENT_SYMBOL=$($PSQL "select symbol from elements where atomic_number=$1 or symbol='$1' or name='$1'")
    ELEMENT_NAME=$($PSQL "select name from elements where atomic_number=$1 or symbol='$1' or name='$1'")
  else
    ELEMENT_ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where symbol='$1' or name='$1'")
    ELEMENT_SYMBOL=$($PSQL "select symbol from elements where symbol='$1' or name='$1'")
    ELEMENT_NAME=$($PSQL "select name from elements where symbol='$1' or name='$1'")
  fi

  if [[ -z $ELEMENT_ATOMIC_NUMBER && -z $ELEMENT_SYMBOL && -z $ELEMENT_NAME ]]
  then
    echo I could not find that element in the database.
  else
    ELEMENT_TYPE=$($PSQL "select type from types right join properties using(type_id) where atomic_number=$ELEMENT_ATOMIC_NUMBER")
    ELEMENT_ATOMIC_MASS=$($PSQL "select atomic_mass from properties where atomic_number=$ELEMENT_ATOMIC_NUMBER")
    ELEMENT_MENTING=$($PSQL "select melting_point_celsius from properties where atomic_number=$ELEMENT_ATOMIC_NUMBER")
    ELEMENT_BOILING=$($PSQL "select boiling_point_celsius from properties where atomic_number=$ELEMENT_ATOMIC_NUMBER")
    echo "The element with atomic number $(echo $ELEMENT_ATOMIC_NUMBER | sed -r 's/^ *| *$//g') is $(echo $ELEMENT_NAME | sed -r 's/^ *| *$//g') ($(echo $ELEMENT_SYMBOL | sed -r 's/^ *| *$//g')). It's a $(echo $ELEMENT_TYPE | sed -r 's/^ *| *$//g'), with a mass of $(echo $ELEMENT_ATOMIC_MASS | sed -r 's/^ *| *$//g') amu. $(echo $ELEMENT_NAME | sed -r 's/^ *| *$//g') has a melting point of $(echo $ELEMENT_MENTING | sed -r 's/^ *| *$//g') celsius and a boiling point of $(echo $ELEMENT_BOILING | sed -r 's/^ *| *$//g') celsius."
  fi
fi
#! /bin/bash 
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

echo Please provide an element as an argument.

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
fi
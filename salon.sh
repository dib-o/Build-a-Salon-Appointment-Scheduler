#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "\nWelcome to My Salon, how can I help you?\n"
MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  SALON_SERVICES=$($PSQL "select * from services")
  echo "HAIR SERVICES - NAIL SERVICES - OTHER SERVICES:"
  echo "$SALON_SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1|2|3|4|5|6|7|8|9|10|11|12|13|14) CHOSEN_SERVICE ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}
CHOSEN_SERVICE(){
  GET_SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
    read SERVICE_TIME
    GET_CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
    INSERT_APPOINTMENT=$($PSQL "insert into appointments(time, customer_id, service_id) values('$SERVICE_TIME','$GET_CUSTOMER_ID','$SERVICE_ID_SELECTED')")
    echo -e "\nI have put you down for a $GET_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  else
    echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
    read SERVICE_TIME
    GET_CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
    INSERT_APPOINTMENT=$($PSQL "insert into appointments(time, customer_id, service_id) values('$SERVICE_TIME','$GET_CUSTOMER_ID','$SERVICE_ID_SELECTED')")
    echo -e "\nI have put you down for a $GET_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}
MAIN_MENU

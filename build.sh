#!/bin/bash

SCRIPT_DIRECTORY="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Configuration
APP_SETTINGS_FILE_NAME="app.settings"
ICON_FILE_NAME="icon.png"
CSS_FILE_NAME="site.css"
DEFAULT_NATIVEFIER_ARGUMENTS=""
TARGET_DIRECTORY="$SCRIPT_DIRECTORY/target"

# Check if nativefier is installed
if ! [ -x "$(command -v nativefier)" ]; then
  echo 'Error: nativefier is not installed. Can not continue.' >&2
  exit 1
fi

# Check if imagemagick is installed
if ! [ -x "$(command -v convert)" ]; then
  echo 'Error: imagemagick is not installed. Can not continue.' >&2
  exit 1
fi

# Read app name from arguments or ask for user input
APP_NAME=""
if [ "$#" -eq  "0" ]
then 
  echo "Please enter the app which should be build!"
  read APP_NAME
else
  APP_NAME=$1
fi 

APP_DIRECTORY="$SCRIPT_DIRECTORY/$APP_NAME"

# Check if the app directory exists
if ! [ -d "$APP_DIRECTORY" ]; then
  echo "Error: Directory for app ${$APP_NAME} not found. Can not continue."
  exit 1
fi

APP_SETTINGS="$APP_DIRECTORY/$APP_SETTINGS_FILE_NAME"

# Check if app.settings exists
if ! [ -f "$APP_SETTINGS" ]; then
  echo "Error: app.settings file for app ${APP_NAME} not found. Can not continue."
  exit 1
fi

pushd ${APP_DIRECTORY} > /dev/null
  SETTINGS_NATIVEFIER_ARGUMENTS=`cat $APP_SETTINGS | tr '\n' ' '`
  GENERATED_NATIVEFIER_ARGUMENTS="$DEFAULT_NATIVEFIER_ARGUMENTS"
  
  if [ -f "$ICON_FILE_NAME" ]; then
    echo "Info: $ICON_FILE_NAME found. Adding icon to arguments"
    GENERATED_NATIVEFIER_ARGUMENTS="$GENERATED_NATIVEFIER_ARGUMENTS --icon $ICON_FILE_NAME"
  fi
  
  if [ -f "$CSS_FILE_NAME" ]; then
    echo "Info: $CSS_FILE_NAME found. Adding inject to arguments"
    GENERATED_NATIVEFIER_ARGUMENTS="$GENERATED_NATIVEFIER_ARGUMENTS --inject $CSS_FILE_NAME"
  fi
	
	
  ARGUMENTS="$GENERATED_NATIVEFIER_ARGUMENTS $SETTINGS_NATIVEFIER_ARGUMENTS $TARGET_PATH"
  TARGET_PATH="$TARGET_DIRECTORY/$APP_NAME"
	
  COMMAND="nativefier $ARGUMENTS $TARGET_PATH"
	
  echo "Executing nativefier: $COMMAND"
  eval "$COMMAND"
	
popd > /dev/null
#!/bin/bash

space=" "

#functions used in this script and/or plugins
function echo_green (){ echo -e "\E[1;32m$1\E[0m"; }
function echo_red (){ echo -e "\E[1;31m$1\E[0m"; }
function echo_brown (){ echo -e "\E[0;33m$1\E[0m"; }
##function encode_message() { echo "$(echo $1 | tr ' ' _)"; }
function add_alert (){
  echo_red "$1 alert: $2"
  alerts=( "${alerts[@]}" "TYPE=${1} MESSAGE=$(echo ${2} | tr ' ' _)" );
}

#erase previous alerts
alerts=( )

#download and read config file
TIMECODE=`date +%s`
echo_green "Starting run for timecode $TIMECODE"

wget -O ./gearbox_config.sh http://ddvtech.com/get_gearbox_settings.php
. ./gearbox_config.sh

#load in all server configs
. ./load_configs.sh

#load in all plugins in numerical order
for plug in ./plugins/*_*.sh; do
  echo_green "Running $plug..."
  . $plug
done

#write all server configs
. ./write_configs.sh
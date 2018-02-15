#!/bin/bash
#######################################################################
#
#  Project......: setup.sh
#  Creator......: matteyeux
#  Description..: Script to install usefull tools for Decrypt0r
#
######################################################################
# Language :
#               bash
# Version : 0.4
#
#  Change Log
#  ==========
#	 DD/MM/YY
#   ===============================================================
#    Date     |       Who          |      What
#   ---------------------------------------------------------------
#    04/10/15 | Mathieu Hautebas   | Script creation
#    02/15/18 | Idabgsram          | Optimized some files

if [[ "$(whoami)" != "root" ]]; then
    echo "Please run this script as root"
    exit 1
fi

if [[ $(uname) != 'Linux' ]]; then
  echo "This script is only for Linux"
  exit 1
fi

git clone --recursive https://github.com/xerub/img4tool ~/Documents/img4tool
cd ~/Documents/img4tool
make -C lzfse
make && cp img4 /usr/local/bin/

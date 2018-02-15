#!/bin/bash
#######################################################################
#
#  Project......: library-iphone.sh
#  Creator......: matteyeux
#  Description..: Script to install libimobiledevice
#  Type.........: Public
#
######################################################################
# Language :
#               bash
# Version : 0.4
#
#  Change Log
#  ==========
#
#   ===============================================================
#    Date     |       Who          |      What
#   ---------------------------------------------------------------
#    27/12/15 |     matteyeux      | Script creation
#   ---------------------------------------------------------------
#    17/08/16 |     matteyeux      | Cleaned script
#   ---------------------------------------------------------------
#    16/02/18 |     idabgsram      | fixed up for ubuntu
#   ---------------------------------------------------------------


function depends(){

        if [[ $(which apt-get) ]]; then
                sudo apt-get install -y git build-essential make autoconf \
                automake libtool openssl tar perl binutils gcc g++ \
                libc6-dev libssl-dev libusb-1.0-0-dev \
                libcurl4-gnutls-dev fuse libxml2-dev \
                libgcc1 libreadline-dev libglib2.0-dev libzip-dev \
                libclutter-1.0-dev  \
                libfuse-dev cython python2.7 \
                libncurses5
        else
                echo "Package manager is not supported"
                exit 1
        fi
}

function build_libimobiledevice(){
        if [[ $(uname) == 'Darwin' ]]; then
                brew link openssl --force
        fi
        successlibs=()
        failedlibs=()
        libs=(  "libusbmuxd" "libimobiledevice" "usbmuxd" \
                "libideviceactivation" "idevicerestore" "ifuse" )

        spinner() {
            local pid=$1
            local delay=0.75
            local spinstr='|/-\'
            echo "$pid" > "/tmp/.spinner.pid"
            while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
                local temp=${spinstr#?}
                printf " [%c]  " "$spinstr"
                local spinstr=$temp${spinstr%"$temp"}
                sleep $delay
                printf "\b\b\b\b\b\b"
            done
            printf "    \b\b\b\b"
        }

        buildlibs() {
                for i in "${libs[@]}"
                do
                        echo -e "\033[1;32mFetching $i..."
                        git clone https://github.com/libimobiledevice/${i}.git
                        cd $i
                        echo -e "\033[1;32mConfiguring $i..."
                        ./autogen.sh
                        ./configure
                        echo -e "\033[1;32mBuilding $i..."
                        make && sudo make install
                        echo -e "\033[1;32mInstalling $i..."
                        cd ..
                done
        }

        buildlibs
        sudo ldconfig
}

if [[ $(uname) == 'Linux' ]]; then
        depends
elif [[ $(uname) == 'Darwin' ]]; then
        echo "this script isn't for other than linux ubuntu"
fi
build_libimobiledevice

#!/bin/bash

#!/bin/bash
#START CMD FAIL FUNCTION
cmdFail () {
if [ $exitStat -ne 0 ]; then
    style=lose
    prt_info    
    gum style "$errMsg"
    sleep 1
    echo
    style=msg
    prt_info
    gum style "This script will now exit"
    exit 1
else
    style=win
    prt_info
    gum style "$successMsg"
    sleep 0.5
fi
# These variables need to be set directly after a process ends to capture the $? value 
# and output a message, cmdFail runs function.
# exitStat=$?
# errMsg="ERROR MESSAGE"
# successMsg="SUCCESS MESSAGE"
# cmdFail
}
#END CMD FAIL FUNCTION

#START GUM STYLE FUNCTION
prt_info () {
case $style in
    info) export FOREGROUND=7; export BOLD=true;; 
    msg) export FOREGROUND=3;; 
    lose) export FOREGROUND=1; export BOLD=true;; 
    win) export FOREGROUND=2; export BOLD=true;; 
    *) export FOREGROUND=7; export BOLD=true;; 
esac 
}
#END GUM STYLE FUNCTION

#START DLGIT FUNCTION
dlGIT () {
    style=info
    prt_info
    gum style "Starting the Installer setup..."
    sleep 1
    echo
    style=msg
    prt_info
    gum style "Cloning pwSetup repository..."
    sleep 1
    echo
    if [ -d "pwSetup" ]; then
        style=msg
        prt_info
        gum style "Directory already exists"
        gum confirm "Do you want to overwrite the directory?"
        exitStat=$?
        if [ "$exitStat" == "0" ]; then
            style=msg
            prt_info
            gum style "Pulling the latest changes from GitHub"
            sleep 1
            cd "pwSetup"
            git pull
            exitStat=$?
            errMsg="Failed to pull repository"
            successMsg="Repository pulled sucessfully"
            cmdFail
        else
            style=msg
            prt_info
            gum style "You have chosen not to overwrite the directory"
            sleep 1
        fi
    else
        style=msg
        prt_info
        gum style "Cloning repository"
        sleep 1
        git clone https://github.com/kevrevrun/pwSetup.git
        exitStat=$?
        errMsg="Failed to clone repository"
        successMsg="Repository cloned sucessfully"
        cmdFail
    fi
}
#END DLGIT FUNCTION
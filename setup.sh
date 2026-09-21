#!/bin/bash

#START INSTALLSETUP FUNCTION
installSetup () {
    echo "Starting the Installer setup..."
    sleep 1
    echo
    echo "Cloning pwSetup repository..."
    sleep 1
    echo
    sleep 1
    if [ -d "pwSetup" ]; then
        echo "Directory already exists"
        echo "Do you want to overwrite the directory? [y/n]"
        read -p "> " confirm
        if [ "$confirm" =~ "^[Yy]$" ]; then
            echo "Pulling the latest changes from GitHub"
            sleep 1
            cd "pwSetup"
            git pull
            exitStat=$?
            errMsg="Failed to pull repository"
            successMsg="Repository pulled sucessfully"
            cmdFail
        else
            echo "You have chosen not to overwrite the directory"
            sleep 1
            installer
        fi
    else
        echo "Cloning repository"
        sleep 1
        git clone https://github.com/kevrevrun/pwSetup.git
        exitStat=$?
        errMsg="Failed to clone repository"
        successMsg="Repository cloned sucessfully"
        cmdFail
    fi
    echo
    echo "Installer setup complete"
    echo
    read -p "Press Enter to continue"
}
#END INSTALLSETUP FUNCTION
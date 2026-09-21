#!/bin/bash

#START BANNER FUNCTION
banner () {
    echo
    echo "---------------------------------------------------------------------------"
    echo "|                           *** KEVREVRUN ***                             |"
    echo "|                                 * & *                                   |"
    echo "|                  *** The Crappy Bash Scripts Group ***                  |"
    echo "|                              * Presents *                               |"
    echo "|                  Practical Debian Wayland DE Installer                  |"
    echo "---------------------------------------------------------------------------"
    echo
    echo
    sleep 1
}
#END BANNER FUNCTION

#START CMDFAIL FUNCTION
cmdFail () {
    if [ $exitStat -ne 0 ]; then
        echo "$errMsg"
        sleep 1
        echo
        echo "This script will now exit"
        read -p "Press [ENTER] key to exit"
        clear
        exit 1
    else
        echo "$successMsg"
    fi
    #These variables need to be set directly after a process ends to capture the $? value and output a message, cmdFail runs function.
    #exitStat=$?
    #errMsg="ERROR MESSAGE"
    #successMsg="SUCCESS MESSAGE"
    #cmdFail
}
#END CMDFAIL FUNCTION

#START INVALID FUNCTION
invalid () {
    clear
    banner
    echo "INVAILD RESPONSE ENTERED!"
    echo "Please enter a vailid response"
    read -p "Press Enter to retry"
}
#END INVALID FUNCTION

#START ADDSUDO FUNCTION
addSudo () {
    echo "Gathering user information"
    sleep 1
    echo
    echo "Enter the username of user to be given sudo permission below"
    read -p "> " sudoUser
    echo "Checking if $sudoUser is a valid user"
    sleep 1
    chkSudoUser=$(cat /etc/passwd | grep -c $sudoUser)
    sleep 1
    if [ "$chkSudoUser" = "1" ]; then
        echo "The user $sudoUser is a valid user!"
        sleep 1
        chkSudo
    else
        invalid
        addSudo
    fi
}
#END ADDSUDO FUNCTION

#START CHKSUDO FUNCTION
chkSudo () {
    echo
    echo "Creating Sudo User"
    sleep 1
    echo "Do you want to give $sudoUser root priviledges [y/n]"
    read -p "> " confirm
    if [ "$confirm" = "y" ]; then
        echo "Root priviledges will be given to $sudoUser..."
        sleep 1
    elif [ "$confirm" = "n" ]; then
        echo "You have chosen not to give $sudoUser root access."
        sleep 1
        add_sudo
    else
        invalid
        chk_sudo
    fi
    echo "Applying sudo group to $sudoUser"
    sleep 1
    usermod -aG sudo $sudoUser 2>&1
    exitStat=$?
    errMsg="Adding $sudoUser to the sudo group failed"
    successMsg="The user $sudoUser now has root access"
    cmdFail
}
#END CHKSUDO FUNCTION

#START ROOTCHK FUNCTION
rootChk () {
    echo "Hold on a sec...They are telling me I need to check ID..."
    sleep 1
    echo "Checking root access..."
    sleep 1
    if [ "$EUID" != 0 ]; then
        echo
        echo "*****************"
        echo "*** IMPORTANT ***"
        echo "*****************"
        echo
        echo "--------------------------------------------------------"
        echo "| Error: Root access not detected!                     |"
        echo "| Login as root and re-run this script.                |"
        echo "| *Note: Debian does not setup a sudo user by default* |"
        echo "--------------------------------------------------------"
        echo
        echo "*****************"
        echo "*** IMPORTANT ***"
        echo "*****************"
        echo
        echo "This script will now exit"
        echo
        sleep 1
        read -p "Press Enter to exit"
        clear
        exit 1
    else
        echo "Root access has been granted!!!"
        sleep 1.5
    fi
}
#END ROOTCHK FUNCTION

#START PKGINSTALL FUNCTION
pkgInstall () {
    echo "Installing Updates & Need Packages"
    sleep 1
    echo
    echo "Refreshing the package cache..."
    apt update
    exitStat=$?
    errMsg="Failed to update package cache"
    successMsg="The package cache has updated sucessfully"
    cmdFail
    apt update | tee output.tmp
    chkUpdates=$(grep -c "packages can be upgraded" output.tmp 2>&1)
    rm output.tmp
    if [ $chkUpdates = 1 ]; then
        echo "The package cache has updated sucessfully"
    fi
    apt update | tee output.tmp
    chkUpdates=$(grep -c "packages can be upgraded" output.tmp 2>&1)
    rm output.tmp
    if [ $chkUpdates = 1 ]; then
        echo "Updates are available."
        sleep 1
        echo "Installing updates"
        DEBIAN_FRONTEND=noninteractive apt upgrade -y
        exitStat=$?
        errMsg="Failed to install updates"
        successMsg="Update prcoess has completed sucessfully"
        cmdFail
    else
        echo
        echo "Update prcoess has completed sucessfully"
        sleep 1
    fi
    echo
    echo "Running apt to install packages..."
    echo
    DEBIAN_FRONTEND=noninteractive apt install sudo fonts-font-awesome unzip git tmux gpg wget curl build-essential whiptail firmware-linux firmware-linux-nonfree -y 2>&1
    exitStat=$?
    errMsg="Failed to install packages"
    successMsg="Package installation has completed sucessfully"
    cmdFail
    echo "Installing Gum..."
    DEBIAN_FRONTEND=noninteractive apt install /tmp/$gumDeb -y --allow-downgrades 2>&1
    exitStat=$?
    errMsg="Gum installed failed"
    successMsg="Gum installed sucessfully"
    cmdFail
    echo
    echo "Initial Setup Completed!"
    echo
    read -p "Press Enter to continue"
}
#END PKGINSTALL FUNCTION



#STARTING SCRIPT
clear
banner
echo "Starting script"
echo
rootChk
echo
echo "Installing Packages"
echo
pkgInstall
echo
echo "Adding Sudo"
echo
addSudo
echo
echo "Getting the Installer ready..."
echo
echo "Downloading Setup Script to /home/$sudoUser"
wget 
installSetup
echo

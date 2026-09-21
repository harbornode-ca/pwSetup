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

#START GUM VARIABLES
#GUM CONFIRM VARIABLES
export GUM_CONFIRM_PROMPT_FOREGROUND=7
export GUM_CONFIRM_SELECTED_FOREGROUND=0
export GUM_CONFIRM_SELECTED_BACKGROUND=3
export GUM_CONFIRM_UNSELECTED_FOREGROUND=0
export GUM_CONFIRM_UNSELECTED_BACKGROUND=2
export GUM_CONFIRM_PADDING="2 0"
export GUM_CONFIRM_SHOW_HELP=false
#END GUM CONFIRM VARIABLES

#START GUM CHOOSE VARIABLES
export GUM_CHOOSE_PADDING="1 0"
export GUM_CHOOSE_HEIGHT=10
export GUM_CHOOSE_CURSOR=" > "
export GUM_CHOOSE_CURSOR_PREFIX="[-] "
export GUM_CHOOSE_SELECTED_PREFIX="[x] "
export GUM_CHOOSE_UNSELECTED_PREFIX="[ ] "
export GUM_CHOOSE_CURSOR_FOREGROUND=7
export GUM_CHOOSE_HEADER_FOREGROUND=3
export GUM_CHOOSE_ITEM_FOREGROUND=3
export GUM_CHOOSE_SELECTED_FOREGROUND=10
#END GUM CHOOSE VARIABLES

#START GUM SPIN VARIABLES
export GUM_SPIN_TITLE="Processing..."
export GUM_SPIN_SPINNER_FOREGROUND=7
export GUM_SPIN_TITLE_FOREGROUND=3 
export GUM_SPIN_SPINNER="dot"
export GUM_SPIN_PADDING="2 0"
#END GUM SPIN VARIABLES

#START GUM STYLE FUNCTION
prt_info (){
case $style in
    info) export FOREGROUND=7; export BOLD=true;;
    msg) export FOREGROUND=3;;
    lose) export FOREGROUND=1; export BOLD=true;;
    win) export FOREGROUND=2; export BOLD=true;;
    *) export FOREGROUND=7; export BOLD=true;;
esac
}
#END GUM STYLE FUNCTION
#END GUM VARIABLES

#START GITDL FUNCTION
gitDL () {
style=info
prt_info
gum style "Downloading the latest version of the installer script"
echo
#Runs the GITDL stub
./data/26095fadf1.sh
}


#START SRCUPDATE FUNCTION
srcUpdate () {
style=info
prt_info
gum style "Removing non-modernized APT sources and setting up Debian Forky sources"
echo
#Runs the APT update stub
./data/260968135b.sh
}

#START SYSUPGRADE FUNCTION
sysUpgrade () {
style=info
prt_info
gum style "Upgrading the system to Debian Forky"
echo
#Runs the APT upgrade stub
./data/2609e9f74a.sh
}
#END SYSUPGRADE FUNCTION


#START MAIN SCRIPT
style=info
prt_info
gum style "Starting Practical Wayland Tools Installer"
echo
gitDL
echo
srcUpdate
echo
sysUpgrade
echo
style=info
prt_info
gum style "The system has been updated to Debian Forky."
echo
style=info
prt_info
gum style "The first step of the Practical Wayland Tools Installer is complete"
sleep 1
style=msg
prt_info
gum style "A reboot is required to complete the upgrade process."
sleep 1
echo
style=info
prt_info
gum style "Once the system reboots, please run installer.sh from $HOME/pwSetup"
gum style "to complete the installation of the practical wayland tools."
echo
gum confirm "Do you want to reboot now?"
exitStat=$?
if [ $exitStat -eq 0 ]; then
    style=msg
    prt_info
    gum style "Rebooting system..."
    sleep 1
    rm -f $HOME/setup.sh
    sudo reboot
    clear
    exit 0
else
    style=msg
    prt_info
    gum style "The system requires a reboot to complete the upgrade process."
    gum style "Please update your system before running setup again."
    gum style "Press <enter> to exit the script"
    rm -f $HOME/setup.sh
    read -p
    exit 0
fi

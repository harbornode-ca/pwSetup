#!/bin/bash
#260968135b.sh - Removes old .list files and the installer generated debian.sources file then adds the forky.sources file.

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

#START APT UPDATE STUB
style=info
prt_info
gum style "Updating APT package cache"
echo
sleep 0.5
sudo apt update 2>&1 > ./pwSetup/data/update.tmp
chkUpgrades=$(cat ./pwSetup/data/update.tmp | grep -c "packages can be upgraded")
numUpdates=$(cat ./pwSetup/data/update.tmp | grep "packages can be upgraded" | cut -d ' ' -f 1)
if [ $chkUpgrades != 0 ]; then
    style=info
    prt_info
    gum style "There are $numUpdates upgrades available!"
    style=msg
    prt_info
    gum style "Updating system"
    gum spin ./pwSetup/data/2609931ea3.sh
    exitStat=$?
    errMsg="APT upgrade failed"
    successMsg="APT upgrade completed successfully"
    cmdFail    
else
    style=info
    prt_info
    gum style "There are no updates available."
    sleep 0.5
    style=info
    prt_info
    gum style "System already up to date."
    sleep 0.5
fi
echo
style=win
prt_info
gum style "Upgrade process completed!"
sleep 1
style=info
prt_info
gum style "The system has been updated to Debian Forky"
sleep 1
style=info
prt_info
gum style "A reboot is required to complete the upgrade process."
sleep 1
#END APT UPDATE STUB
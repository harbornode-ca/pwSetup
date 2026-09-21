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


#START SETUP APT SOURCES STUB
style=info
prt_info
gum style "Removing old format .list files..."
sleep 0.5
oldRepos=$(find /etc/apt -name "sources.list*" -not -regex ".*/sources.list.d.*")
for r in $oldRepos; do
    style=msg
    prt_info
    gum style "Removing $r"
    sudo rm -f $r
    exitStat=$?
    errMsg="Removing $r failed"
    successMsg="Removed $r successfully"
    cmdFail
    sleep 0.25 
done
echo
style=info
prt_info
gum style "Successfully removed old format .list files."
sleep 0.5
echo
style=info
prt_info
gum style "Removing Debian installer generated source file"
if [ -f /etc/apt/sources.list.d/debian.sources ]; then
    style=msg
    prt_info
    gum style "Removing /etc/apt/sources.list.d/debian.sources"
    sudo rm -f /etc/apt/sources.list.d/debian.sources
    exitStat=$?
    errMsg="Debian installer generated source file removal failed"
    successMsg="Debian installer generated source file removed successfully"
    cmdFail
    sleep 0.25    
else
    style=win
    prt_info
    gum style "No installer generated modernized source file detected."
    sleep 0.5
fi
style=info
prt_info
gum style "Successfully removed APT configuration files"
echo
gum style "Copying forky.sources to /etc/apt/sources.list.d/"
sleep 0.5
sudo cp -f "./data/forky.sources" "/etc/apt/sources.list.d/forky.sources"
exitStat=$?
errMsg="Copying forky.sources to /etc/apt/sources.list.d/ failed"
successMsg="Successfully copied forky.sources to /etc/apt/sources.list.d/"
cmdFail    
echo
#END SETUP APT SOURCES STUB

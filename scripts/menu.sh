#!/bin/bash
# A menu driven shell script sample template 
## ----------------------------------
# Step #1: Define variables
# ----------------------------------
EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'
 
# ----------------------------------
# Step #2: User defined function
# ----------------------------------
pause(){
  read -p "Press [Enter] key to continue..." fackEnterKey
}

one(){
	echo "one() called"
        pause
}
 
# do something in two()
two(){
	echo "two() called"
        pause
}
 
# function to display menus
show_menus() {
	clear
	echo Welcome to the PlexGuide Installer v3.5 | 0001
	echo
	echo "~~~~~~~~~~~~~~~~~~~~~"	
	echo " M A I N - M E N U"
	echo "~~~~~~~~~~~~~~~~~~~~~"
	echo "1. Install - Mass Programs (Only for a New Server)"
	echo "2. Install - Individual Programs"
	echo "3. Update PlexGuide"
	echo "4. Exit"
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
	local choice
	read -p "Enter choice [ 1 - 4] " choice
	case $choice in
		1)
        cd /opt/plexguide/scripts/
        bash mass.sh
                ;;
		2) 
        cd /opt/plexguide/scripts/
		bash dep2.sh
		bash individual-menu.sh
		;;
		3) 
        cd /opt/plexguide/scripts/
        bash upgrade.sh
        bash continue.sh
        ;;
        4)
        exit 0;;
		*) echo -e "${RED}Error...${STD}" && sleep 2
	esac
}
 
# ----------------------------------------------
# Step #3: Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP
 
# -----------------------------------
# Step #4: Main logic - infinite loop
# ------------------------------------
while true
do
 
	show_menus
	read_options
done


            
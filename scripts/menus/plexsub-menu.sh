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
cat << EOF
~~~~~~~~~~~~~~~~~~
PLEX SERVER SELECT
~~~~~~~~~~~~~~~~~~

Note, if you install the PlexPass version and do not have PlexPass, it will
just revert to the normal version. If your installing this on a REMOTE
computer, please visit http://wiki.plexguide.com so you access the server!

1. Install Latest Plex Server (Public - Stable)
2. Install Latest Plex Server (Pass - Unstable)

EOF
}

read_options(){
	local choice
	read -p "Enter choice [ 1 - 3 ];  Type [3] to Exit!  " choice
	case $choice in
		1)
        #file="/var/plexguide/plextoken.yes"
        #if [ -e "$file" ]
        #then
        docker rm plexpass
        docker rm plexpublic
        clear
        echo ymlprogram plexpublic > /opt/plexguide/tmp.txt
        echo ymldisplay Plex Public >> /opt/plexguide/tmp.txt
        echo ymlport 32400 >> /opt/plexguide/tmp.txt
        bash /opt/plexguide/scripts/docker-no/program-installer.sh
        clear
        #else
        #echo
        #echo "Are you Special? You need to setup your PLEXTOKEN FIRST!!!"
        #echo
        #read -n 1 -s -r -p "Press any key to continue "
        ##fi
      ;;
		2)
        #file="/var/plexguide/plextoken.yes"
        #if [ -e "$file" ]
        #then
        docker rm plexpublic
        docker rm plexpass
        clear
        echo ymlprogram plexpass > /opt/plexguide/tmp.txt
        echo ymldisplay Plex Pass >> /opt/plexguide/tmp.txt
        echo ymlport 32400 >> /opt/plexguide/tmp.txt
        bash /opt/plexguide/scripts/docker-no/program-installer.sh
        clear
        ##else
        #echo
        #echo "Are you Special? You need to setup your PLEXTOKEN FIRST!!!"
        #echo
        #read -n 1 -s -r -p "Press any key to continue "
        ##fi
      ;;
      3)
      exit 0;;
      4)
      clear
      echo "Visit http://plex.tv/claim"
      echo
      read -p "What is your Plex Claim Token? " pmstoken
      echo "PMSTOKEN=$pmstoken" >> /opt/.environments/.plex-env
      clear
      touch /var/plexguide/plextoken.yes
      echo "Your PlexToken is Installed for the Easy Setup!"
      echo
      read -n 1 -s -r -p "Press any key to continue "
      ;;
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

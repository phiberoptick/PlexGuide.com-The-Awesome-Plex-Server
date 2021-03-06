#!/bin/bash
# A menu driven shell script sample template
## ----------------------------------
# Step #1: Define variables
# ----------------------------------
EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'

bash /opt/plexguide/scripts/delugevpn/openvpn-setup.sh


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
~~~~~~~~~~~~~~~~~~~~~~~~
VPN Torrents
~~~~~~~~~~~~~~~~~~~~~~~~

Note, make sure that you have an account with PIA before installing otherwise
it will not work! Please visit https://www.privateinternetaccess.com to join.

Currently only 8 PIA servers support port forwarding.
Choices are: CA Montreal, CA Toronto, Netherlands, Switzerland,
             Sweden, France, Romania or Israel.

Default is set to Netherlands
(To change edit /opt/plexguide/scripts/delugevpn/move-ovpn.sh before install)


1. PIA VPN details
2. Install DelugeVPN
3. Install rTorrentVPN
4. Exit


*** Use http://iknowwhatyoudownload.com or TorGuard's CheckMyTorrentIP Tool
    to check for leaks! ***

Please visit https://github.com/binhex/ for further info if you want to use
a different VPN provider.

EOF
}


read_options(){
	local choice
	read -p "Enter choice [ 1 - 4 ] " choice
	case $choice in
    1)
    rm /opt/appdata/delugevpn/.deluge-env
    # Get IP Address
    local_ip=`hostname -I | awk '{print $1}'`
    # CIDR - this assumes a 255.255.255.0 netmask
    lan_net=`hostname -I | awk '{print $1}' | sed 's/\.[0-9]*$/.0\/24/'`
    echo "IP_ADDRESS=$local_ip" >> /opt/appdata/delugevpn/.deluge-env
    echo "LAN_NETWORK=$lan_net" >> /opt/appdata/delugevpn/.deluge-env

    clear
    echo "Visit https://www.privateinternetaccess.com for account details. "
    echo
    read -p "What is your PIA Username?: " pia_username
    echo "VPN_USER=$pia_username" >> /opt/appdata/delugevpn/.deluge-env
    echo
    read -s -p "What is your PIA Password? (Will not be echoed): " pia_password
    echo "VPN_PASS=$pia_password" >> /opt/appdata/delugevpn/.deluge-env
    echo
    cat /opt/appdata/delugevpn/.deluge-env >> /opt/plexguide/scripts/docker/.env
    bash /opt/plexguide/scripts/delugevpn/basic-env.sh
    cat /opt/appdata/.env >> /opt/appdata/delugevpn/.deluge-env

  #  read -p "What Remote server do you want to use? : " vpn_remote_choice
  #  echo "VPN_REMOTE=$vpn_remote_choice.privateinternetaccess.com" >> /opt/.environments/.deluge-env
  #  echo
    clear
    touch /var/plexguide/pia-vpn-set.yes
    echo "Your PIA info has been Installed for the Easy Setup!"
    echo
    echo "Remember to use http://iknowwhatyoudownload.com  "
    echo "to check if your IP is leaked after using deluge or "
    echo "use TorGuard's Check My Torrent IP Tool."
    echo
    echo
    echo "       *** THE DEFAULT PASSWORD IS deluge ***        "
    echo
    echo
    read -n 1 -s -r -p "Press any key to continue "
    ;;
		2)
      file="/var/plexguide/pia-vpn-set.yes"
      if [ -e "$file" ]
      then
        docker rm rtorrentvpn
        bash /opt/plexguide/scripts/delugevpn/deluge.sh
      #  sudo usermod -aG docker $USER

    #    echo ymlprogram uhttpd > /opt/plexguide/tmp.txt
    #    echo ymldisplay UHTTPD >> /opt/plexguide/tmp.txt
    #    echo ymlport 80 >> /opt/plexguide/tmp.txt
    #    bash /opt/plexguide/scripts/docker-no/program-installer.sh
    #    clear
    #    bash /opt/plexguide/scripts/delugevpn/daemon.sh
        clear
      else
        echo
        echo "Are you Special? You need to setup your PIA account details first!!!"
        echo
        read -n 1 -s -r -p "Press any key to continue "
      fi
      ;;
    3)
    file="/var/plexguide/pia-vpn-set.yes"
    if [ -e "$file" ]
    then
      docker rm delugevpn
      bash /opt/plexguide/scripts/delugevpn/rtorrent.sh
      clear
    else
     echo
     echo "Are you Special? You need to setup your PIA account details first!!!"
     echo
     read -n 1 -s -r -p "Press any key to continue "
   fi
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

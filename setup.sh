#!/bin/bash
#
# GRC-Netdata single line install with custom support.
#
# Supports:
#	Ubuntu/Debian
#
# Future Supports:
#	Fedora
#	openSUSE
#	REHL
#	ARCH
#	Anything else netdata and gridcoin support
#
# Set colors
TY="\033[1;32m[Y]\033[m"
TN="\033[1;33m[N]\033[m"
TD="\033[1;35m[-]\033[m"
TW="\033[1;33m[W]\033[m"
TI="\033[1;34m[I]\033[m"
TQ="\033[1;36m[?]\033[m"
TE="\033[1;31m[E]\033[m ERROR: "
#
# Hardcoded Values
GRCCONF='/usr/local/bin/grc-netdata.conf'
BINFOLDER='/usr/local/bin'
#
# Functions here

# echo coloured out with proper output // Time saver!
function eo {

	# Easier to format echos :)
	# ARG 1 is type of message
	# ARG 2 is message
	if [[ "$1" == "Y" ]]
	then
		echo -e ${TY} ${2}
	elif [[ "$1" == "N" ]]
	then
		echo -e ${TN} ${2}
	elif [[ "$1" == "I" ]]
	then
		echo -e ${TI} ${2}
	elif [[ "$1" == "W" ]]
	then
		echo -e ${TW} ${2}
	elif [[ "$1" == "D" ]]
	then
		echo -e ${TD} ${2}
	elif [[ "$1" == "E" ]]
	then
		echo -e ${TE} ${2}
	else
		echo BAD SYNTAX ON EOUT
		exit 1
	fi
}

# Ask a question and place it in a value from outside of a function that I choose.
function ei {

	# Ask questions easier. Reply in substituted value?
	# $1 is type
	# $2 output string. ex value will become $value.
	# $3 and on is question
	if [[ "$1" == "1" ]]
	then
		read -p "$(echo -e ${TQ}" ${3} ")" -n 1 "${2}"
		echo
		return 1
	elif [[ "$1" == "2" ]]
	then
		read -p "$(echo -e ${TQ}" ${3} ")" "${2}"
		return 1
	else
		echo BAD READ SYNTAX
		exit 1
	fi
}

# Root Check

function check_root {

	eo D "Checking UID.."
	checkroot=$(id | cut -d "=" -f2- | rev | cut -d "(" -f4-)
	if [[ "$checkroot" == "0" ]]
	then
		eo I "DETECTED: UID=0"
		eo Y "Do we have root privilege?"
		return 1
	else
		eo I "DETECTED: UID=$checkroot"
		eo N "Do we have root privilege?"
		eo E "This install needed root privileges."
		eo I "Try 'sudo ./setup.sh'"
		eo E "Exiting."
		exit 1
	fi

}

# Release check (2 methods)

function check_release {

	eo D "Checking release information.."
	if [[ -s /usr/bin/lsb_release ]]
	then
		eo Y "Was lsb_release found?"
		osrelease=$(lsb_release -i | cut -d ":" -f2- | tr -d "\t")
		if [[ "$osrelease" == "Ubuntu" || "$osrelease" == "Debian" ]]
		then
			eo I "Release is $osrelease"
			eo I "Installing for Ubuntu/Debian.."
			os="1"
			return 1
		else
			eo I "Release is $osrelease"
			eo E "$osrelease is currently not supported.."
			eo E "Exiting.."
			exit 1
		fi
	else
		eo N "Was lsb_release found?"
	fi
	eo D "List of supported releases:"
	eo I "1) Ubuntu/Debian"
	eo I "2) Not yet implemented"
	ei 1 os_release "Please select your distribution:"
	if [[ "$os_release" == "1" ]]
	then
		eo D "Installing for Ubuntu/Debian.."
		os="1"
		return 1
	else
		eo E "Bad input.."
		eo E "Exiting.."
		exit 1
	fi
	exit 1

}
# Start here

echo
echo
eo D "Welcome to GRC-Netdata installation."
eo D
eo I "STDERR information is stored in setup.err"
eo D
eo D "Running preinstall checks.."

# Preinstall checks.

check_root
check_release

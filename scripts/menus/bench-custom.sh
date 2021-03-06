#!/bin/bash

clear

function contextSwitch {
   {
   ctxt1=$(grep ctxt /proc/stat | awk '{print $2}')
       echo 50
   sleep 1
       ctxt2=$(grep ctxt /proc/stat | awk '{print $2}')
       ctxt=$(($ctxt2 - $ctxt1))
       result="Number os context switches in the last secound: $ctxt"
   echo $result > result
   } | whiptail --gauge "Getting data ..." 6 60 0
}


function userKernelMode {
   {
   raw=( $(grep "cpu " /proc/stat) )
       userfirst=$((${raw[1]} + ${raw[2]}))
       kernelfirst=${raw[3]}
   echo 50
       sleep 1
   raw=( $(grep "cpu " /proc/stat) )
       user=$(( $((${raw[1]} + ${raw[2]})) - $userfirst ))
   echo 90
       kernel=$(( ${raw[3]} - $kernelfirst ))
       sum=$(($kernel + $user))
       result="Percentage of last sekund in usermode: \
       $((( $user*100)/$sum ))% \
       \nand in kernelmode: $((($kernel*100)/$sum ))%"
   echo $result > result
   echo 100
   } | whiptail --gauge "Getting data ..." 6 60 0
}

function interupts {
   {
   ints=$(vmstat 1 2 | tail -1 | awk '{print $11}')
       result="Number of interupts in the last secound:  $ints"
   echo 100
   echo $result > result
   } | whiptail --gauge "Getting data ..." 6 60 50
}

while []
do
VARS=$(
whiptail --title "Advanced System and Bechnmark Options" --checklist "Choose Variables for the Information and Benchmark Run" 15 60 4 \
    "-info" "System Information" OFF \
    "-io" "I/O Test" OFF \
    "-cdn" "CDN Download" OFF \
    "-northamerica" "North America Download" OFF \
    "-europe" "Europe Download" OFF \
    "-asia" "Asia Download"
    3>&1 1>&2 2>&3
)

echo $VARS

echo "Do you want to run BASIC benchmark and information? (y/n)? "
old_stty_cfg=$(stty -g)
stty raw -echo
answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
stty $old_stty_cfg
if echo "$answer" | grep -iq "^y" ;then
    echo Yes;

  curl -LsO raw.githubusercontent.com/sayem314/serverreview-benchmark/v3-dev/bench.sh; chmod +x bench.sh
  echo
  ./bench.sh $VARS

else
  bash /opt/plexguide/scripts/menus/bench-menu.sh

read -n 1 -s -r -p "Press any key to continue "
clear

fi

esac
done
exit

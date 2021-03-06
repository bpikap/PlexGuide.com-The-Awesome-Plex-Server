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

while [ 1 ]
do
CHOICE=$(
whiptail --title "Program Categories" --menu "Make your choice" 16 26 9 \
    "1)" "Media Servers"  \
    "2)" "NZBs"  \
    "3)" "Torrents"  \
    "4)" "Managers"  \
    "5)" "Supporting"  \
    "6)" "UI Organizers"  \
    "7)" "Critical"  \
    "8)" "Beta Testing"  \
    "9)" "Exit  "  3>&2 2>&1 1>&3
)

result=$(whoami)
case $CHOICE in
    "1)")
    clear
    bash /opt/plexguide/scripts/menus/programs/program-media.sh
    ;;

    "2)")
    clear
    bash /opt/plexguide/scripts/menus/programs/program-nzbs.sh
    ;;

    "3)")
    clear
    bash /opt/plexguide/scripts/menus/programs/program-torrent.sh
    ;;

    "4)")
    clear
    bash /opt/plexguide/scripts/menus/programs/program-managers.sh
    ;;

    "5)")
    clear
    bash /opt/plexguide/scripts/menus/programs/program-support.sh
    ;;

    "6)")
    clear
    bash /opt/plexguide/scripts/menus/programs/program-ui.sh
    ;;

    "7)")
    clear
    bash /opt/plexguide/scripts/menus/programs/program-critical.sh
    ;;

    "8)")
    clear
    bash /opt/plexguide/scripts/menus/programs/program-beta.sh
    ;;

    "9)")
      clear
      exit 0
      ;;
esac
done
exit

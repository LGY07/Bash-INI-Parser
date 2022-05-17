#!/bin/bash
##INI parser for bash
INI_Parser() {
NAME='_'$2
SECTION_NUM=$(grep "^\\[" $1 | grep "]$" | wc -l)
SEC_TIMES=1
export $NAME'__SECTIONS'=$(grep "^\\[" $1 | grep "]$" | sed "s/^\\[//" | sed "s/]$//")
while [[ $SEC_TIMES -le $SECTION_NUM ]]
do
    let SEC_TIMES_ADD=$SEC_TIMES+1
    SECTION_NAME_A=$(grep "^\\[" $1 | grep "]$" | sed "s/^\\[//" | sed "s/]$//" | grep -n "" | grep "^$SEC_TIMES" | sed "s/^$SEC_TIMES://")
    SECTION_NAME_B=$(grep "^\\[" $1 | grep "]$" | sed "s/^\\[//" | sed "s/]$//" | grep -n "" | grep "^$SEC_TIMES_ADD" | sed "s/^$SEC_TIMES_ADD://")
    let STA_LINE=$(cat $1 | grep "^\\[$SECTION_NAME_A]" -n | grep -Eo '^[0-9]*')+1
    if [[ $SEC_TIMES -eq $SECTION_NUM ]];then END_LINE=$(cat $1 | wc -l)
    else let END_LINE=$(cat $1 | grep "^\\[$SECTION_NAME_B]" -n | grep -Eo '^[0-9]*')-1;fi
    KEY_NUM=$(cat $1 | sed -n "$STA_LINE,$END_LINE p" | grep -v "^;" | wc -l)
    KEY_TIMES=1
    export $NAME'__SEC'$SEC_TIMES=$(grep "^\\[" $1 | grep "]$" | sed "s/^\\[//" | sed "s/]$//" | grep -n "" | grep "^$SEC_TIMES" | sed "s/^$SEC_TIMES://")
    while [[ $KEY_TIMES -le $KEY_NUM ]]
    do
        export $NAME'_'$SECTION_NAME_A'_'$(cat $1 | sed -n "$STA_LINE,$END_LINE p" | grep -v "^;" | grep -v -e '^$'| grep -n "" | grep "^$KEY_TIMES" | sed "s/^$KEY_TIMES://")
        let KEY_TIMES=$KEY_TIMES+1
    done
    let SEC_TIMES=$SEC_TIMES+1
done
#return 0
}
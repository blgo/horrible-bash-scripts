#!/bin/bash
function moon {
while true; 
do
 BG=$1
 FG=white
 #moonstatus="$(cat  ./.weatherforecast | sed '/luna/!d' | awk '{print$2}' | sed 's/\%//')"
moonstatus="$(cat ./test)"
 pix1="$(echo "($moonstatus/100*17)-18" | bc -l)"
 pix2="$((${pix1%.*}-1))"
if [ "$(cat  ./.weatherforecast | sed '/luna/!d' | awk '{print$3}' | sed 's/\%//')" -lt $moonstatus ]
then
pix3=-$pix2-17
fi	
 pix1="$(echo "($moonstatus/100*17)-18" | bc -l)"
 pix2="$((${pix1%.*}-1))"
 echo "^ib(1)^pa(17)^fg($FG)^c(17)^p($pix2)^fg($BG)^c(17) ^ib(0)"
sleep 2
done
}
moon black | dzen2 

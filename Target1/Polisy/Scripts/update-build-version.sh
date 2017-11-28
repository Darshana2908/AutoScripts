#!/bin/bash
#MonthDayVersion=$(date +%m.%d)

#Month & Date
MonthDayVersion=$(date -d "-1 days" +"%m.%d")

#Build Version
ver="RC17.2-$MonthDayVersion"

#Updating Latest version in Polisy
sed -i "s/\(<Version>\)[^<]*\(<\/Version>\)/\1$ver\2/" /data3/guest/integral77/target1/polisy77/conf/QuipozCfg.xml

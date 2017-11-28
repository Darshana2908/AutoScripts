#!/bin/bash
#Git Pull all cloned repos and get logs date wise

if [ $# -eq 0 ]
	  then
		 echo " ********************************
		 
		   This scripts needs a date to run......
		   
		   Please enter the date for which you want to have logs

		   exiting scipt for now"

		   exit 1
		   
	      fi

parm1=$1
#parm2= `echo $parm1 | sed -e 's,_, ,g'`

echo $parm1

echo starting Script with given date $parm1

cat /dev/null > /tmp/repo_op.log

for repo in `cat ~/Desktop/repos.txt`

do
echo $repo
cd $repo
git pull
git log >> /tmp/repo_op.log
done

egrep  -A 4 -B 2 "$parm1" /tmp/repo_op.log > /tmp/outputprod.log

echo please check your o/p in /tmp/outputprod.log

@echo off
:: change the current directory 
cd G:\integral\app\life\deployv2\_builds_Admin-Batchjob
G:
::Download packages
wget http://20.194.56.53/builds/life-base/MBRDATA/MBRDATA.war
wget http://20.194.56.53/builds/life-base/admin/CSCLifeAsiaWeb.war
wget http://20.194.56.53/builds/life-base/batch/csc-smart400-batch.zip

exit


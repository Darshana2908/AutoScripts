@echo off
:: change the current directory 
cd G:\integral\app\pnc\deployv2\_builds_Admin-Batchjob
G:
::Download packages
wget http://20.194.56.53/builds/polisy-base/MBRDATA/MBRDATA.war
wget http://20.194.56.53/builds/polisy-base/admin/PolisyAsiaWeb.war
wget http://20.194.56.53/builds/polisy-base/batch/csc-smart400-batch.zip

exit


@echo off
:: change the current directory 
cd G:\integral\app\group\deployv2\_builds_Admin-Batchjob
G:
::Download packages
wget http://20.194.56.53/builds/group-base/MBRDATA/MBRDATA.war
wget http://20.194.56.53/builds/group-base/admin/CSCGroupAsiaWeb.war
wget http://20.194.56.53/builds/group-base/batch/csc-smart400-batch.zip

exit


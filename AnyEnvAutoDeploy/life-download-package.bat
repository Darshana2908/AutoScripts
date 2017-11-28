@echo off
:: Create temp folder
mkdir H:\integral\app\regression\R16.2_Life_FTtesting\_builds\temp
echo "temp folder created"

cd H:\integral\app\regression\R16.2_Life_FTtesting\_builds\temp\
H:
echo "in temp folder now"

::Download admin
::wget http://20.198.58.172/builds/lifelocalteam/MBRDATA/MBRDATA.war
wget http://20.198.58.172/builds/lifelocalteam/admin/CSCLifeAsiaWeb.war
::Download batch
wget http://20.198.58.172/builds/lifelocalteam/batch/csc-smart400-batch.zip
echo "admin and batch downloaded"

::Copy package in latest_builds folder
copy H:\integral\app\regression\R16.2_Life_FTtesting\_builds\temp\* H:\integral\app\regression\R16.2_Life_FTtesting\latest_builds\
echo "downloaded files copied in latest_builds folder"

::Rename the temp folder
cd ..
move H:\integral\app\regression\R16.2_Life_FTtesting\_builds\temp H:\integral\app\regression\R16.2_Life_FTtesting\_builds\"Life-%date:/=-%-%time::=-%"
echo "temp folder renamed"


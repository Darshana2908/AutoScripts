@echo off
cd /D %~dp0

call H:\integral\app\regression\R16.2_Life_FTtesting\scripts\life-download-package.bat >> H:\integral\app\regression\R16.2_Life_FTtesting\scripts\ldp.txt

call H:\integral\app\regression\R16.2_Life_FTtesting\scripts\auto-deploy-batch.bat >> H:\integral\app\regression\R16.2_Life_FTtesting\scripts\adb.txt

call H:\integral\app\regression\R16.2_Life_FTtesting\scripts\auto-deploy-admin.bat >> H:\integral\app\regression\R16.2_Life_FTtesting\scripts\ada.txt

exit 
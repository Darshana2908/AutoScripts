@echo off
cd /D %~dp0
G:

sc stop POLISY_ADMIN

xcopy /Y G:\integral\app\pnc\VPMSON\QuipozCfg.xml G:\integral\app\pnc\conf

sc start POLISY_ADMIN

exit
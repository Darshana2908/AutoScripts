@echo off
cd /D %~dp0
G:

sc stop LIFE_ADMIN

xcopy /Y G:\integral\app\life\VPMSOFF\QuipozCfg.xml G:\integral\app\life\conf

sc start LIFE_ADMIN

exit
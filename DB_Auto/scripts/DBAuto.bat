@echo off

:: copy the files from source to destination by no of days old /MAXAGE:1
::robocopy F:\DB_Auto\Group F:\DB_Auto\All /E /MAXAGE:1 /XD .svn
::robocopy F:\DB_Auto\Group_batch F:\DB_Auto\All /E /MAXAGE:1 /XD .svn
::robocopy F:\DB_Auto\Integral_Commons F:\DB_Auto\All /E /MAXAGE:1 /XD .svn
::robocopy F:\DB_Auto\Life F:\DB_Auto\All /E /MAXAGE:1 /XD .svn
::robocopy F:\DB_Auto\Life_batch F:\DB_Auto\All /E /MAXAGE:1 /XD .svn
::robocopy F:\DB_Auto\Pnc F:\DB_Auto\All /E /MAXAGE:1 /XD .svn
::robocopy F:\DB_Auto\Pnc_batch F:\DB_Auto\All /E /MAXAGE:1 /XD .svn
::robocopy F:\DB_Auto\OneCompany F:\DB_Auto\All /E /MAXAGE:1 /XD .svn


:: copy .sql files to folder from where we want to execute
::FORFILES /S /P F:\DB_Auto\All /M *.sql /C "cmd /c copy @file F:\DB_Auto\Execute"

::Server Connection

set servername=20.198.58.32
set dbname=LBASE-5-0622
set username=lbase
set password=lbase12#$
set spath=D:\DB_Auto\Execute
set logfilepath= D:\DB_Auto\Temp\logs\output_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%hr%%time:~3,2%%time:~6,2%.log
set cmd='dir %spath%\*.sql /b/s'

:: execution of .sql files one by one

FOR /F "tokens=*" %%G IN (%cmd%) DO ( 

echo ******PROCESSING %%G FILE****** >> %logfilepath%
sqlcmd -S %servername% -U %username% -P %password% -d %dbname% -i"%%G" >> %logfilepath%

)


set logpath= F:\DB_Auto\Temp\logs\_%date:~-4,4%%date:~-10,2%%date:~-7,2%_%hr%%time:~3,2%%time:~6,2%.log


rd /q /s D:\DB_Auto\All

mkdir D:\DB_Auto\All
:: after executing it will take backups of all the file in a folder named "DBBackups"
set dname=%date:~-7,2%-%date:~-10,2%_%hh%%time:~3,2%%time:~6,2%
mkdir "D:\DB_Auto\Temp\%dname%"

robocopy D:\DB_Auto\Execute "F:\DB_Auto\Temp\%dname%" /E >>  %logpath%
del /Q D:\DB_Auto\Execute\*
::echo %errorlevel%

::set /p delExit=Press the ENTER key to exit...: 

@echo off
cd /D %~dp0
call SVNUpdate_Group_batch.bat

::call update.bat for each svn/git repo cloned to store the .sql files


::pause
exit
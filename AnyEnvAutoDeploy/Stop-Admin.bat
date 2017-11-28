@echo off
FOR /F "tokens=5 delims= " %%P IN ('netstat -a -n -o ^| findstr :9444') DO taskkill /F /PID %%P
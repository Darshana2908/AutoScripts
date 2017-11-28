@echo off
::Stop Admin
sc stop Life_FTtesting
call H:\integral\app\regression\R16.2_Life_FTtesting\scripts\Stop-Admin.bat
echo "calling Stop-Admin"

ping 127.0.0.1 -n 10 > nul

:: deleting temp folder
rd /s /q H:\integral\app\regression\R16.2_Life_FTtesting\wildfly-10.0.0.Final\standalone\tmp
echo "temp folder deleted"

::Create temp folder
mkdir H:\integral\app\regression\R16.2_Life_FTtesting\_backup\admin\temp
echo "temp folder created"

::Backup admin
move H:\integral\app\regression\R16.2_Life_FTtesting\wildfly-10.0.0.Final\standalone\deployments\CSCLifeAsiaWeb.war H:\integral\app\regression\R16.2_Life_FTtesting\_backup\admin\temp\
echo "war file backed up"

::Rename temp folder
move H:\integral\app\regression\R16.2_Life_FTtesting\_backup\admin\temp H:\integral\app\regression\R16.2_Life_FTtesting\_backup\admin\"Life-Admin-%date:/=-%-%time::=-%"
echo "temp folder renamed"

::Deleting war
del /Q H:\integral\app\regression\R16.2_Life_FTtesting\wildfly-10.0.0.Final\standalone\deployments\CSCLifeAsiaWeb.war.deployed
echo "existing deployed file deleted"

::Modify admin
cd H:\integral\app\regression\R16.2_Life_FTtesting\latest_builds\
H:
echo "in latest_builds folder now"

7z d "CSCLifeAsiaWeb.war" "WEB-INF\web.xml"
7z u "CSCLifeAsiaWeb.war" "WEB-INF\web.xml"
7z u "CSCLifeAsiaWeb.war" "WEB-INF\jboss-deployment-structure.xml"			
7z u "CSCLifeAsiaWeb.war" "WEB-INF\jboss-web.xml"
7z d "CSCLifeAsiaWeb.war" "WEB-INF\classes\logback.xml"
7z u "CSCLifeAsiaWeb.war" "WEB-INF\classes\logback.xml"

echo "all files replaced"

::Moving war to deployment folder
move CSCLifeAsiaWeb.war H:\integral\app\regression\R16.2_Life_FTtesting\wildfly-10.0.0.Final\standalone\deployments\CSCLifeAsiaWeb.war
echo "war file moved to deployment folder"

::Start Admin
sc start Life_FTtesting

echo "Admin Deployed Successfully"
::pause




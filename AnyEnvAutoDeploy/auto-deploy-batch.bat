@echo off
::Stop Batchjob
schtasks /end /tn "Life_FTtesting_Batch" 
::Creat temp folder
mkdir H:\integral\app\regression\R16.2_Life_FTtesting\_backup\batch\temp
echo "folder created"

::backup Batchjob
move H:\integral\app\regression\R16.2_Life_FTtesting\batchjob\csc-smart400-batch H:\integral\app\regression\R16.2_Life_FTtesting\_backup\batch\temp\
ping 127.0.0.1 -n 10 > nul
echo "batch backup done"

::Rename temp folder
move H:\integral\app\regression\R16.2_Life_FTtesting\_backup\batch\temp H:\integral\app\regression\R16.2_Life_FTtesting\_backup\batch\"Life-Batch-%date:/=-%-%time::=-%"
echo "temp folder renamed"

::Copy latest batchjob from latest_builds folder to batchjob folder
move H:\integral\app\regression\R16.2_Life_FTtesting\latest_builds\csc-smart400-batch.zip H:\integral\app\regression\R16.2_Life_FTtesting\batchjob\
echo "batch replaced"

::Unzip batch
cd H:\integral\app\regression\R16.2_Life_FTtesting\batchjob\
H:
echo "in batchjob now"

7z x -y csc-smart400-batch.zip
echo "extracted"

del csc-smart400-batch.zip
echo "deleted zip"

7z a -y csc-smart400-batch\csc-smart400-batch-1.0-SNAPSHOT.jar H:\integral\app\regression\R16.2_Life_FTtesting\config-new\batch\logback.xml
echo "Logback replaced"
:: Start Batchjob
schtasks /run /tn "Life_FTtesting_Batch" 
echo "Batch Deployed Successfully"
::pause


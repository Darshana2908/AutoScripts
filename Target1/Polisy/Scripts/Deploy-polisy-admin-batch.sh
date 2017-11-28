# stop batchjob
/data3/guest/integral77/target1/polisy77/scripts/pnc77_stopbatch.sh
sleep 15
#stop polisy-admin
/data3/guest/integral77/target1/polisy77/scripts/pnc77_stop.sh
sleep 20

#update build version
/data3/guest/integral77/target1/polisy77/scripts/update-build-version.sh

#########################ADMIN#############################
#back up admin
mv /data3/guest/integral77/target1/polisy77/jboss-eap-6.4/standalone/deployments/PolisyAsiaWeb.war /data3/guest/integral77/target1/polisy77/backup/Latest/
mv /data3/guest/integral77/target1/polisy77/jboss-eap-6.4/standalone/deployments/MBRDATA.war /data3/guest/integral77/target1/polisy77/backup/Latest/

# clear deployment folder
rm -rf /data3/guest/integral77/target1/polisy77/jboss-eap-6.4/standalone/deployments/*
#copy latest admin package from builds folder to deployv2/admin
mv /data3/guest/integral77/target1/polisy77/builds/Latest/PolisyAsiaWeb.war /data3/guest/integral77/target1/polisy77/deployv2/admin/
#cd in admin folder
cd /data3/guest/integral77/target1/polisy77/deployv2/admin/
# config updates
zip -d PolisyAsiaWeb.war -xi WEB-INF/web.xml
zip -u PolisyAsiaWeb.war -xi WEB-INF/web.xml
zip -u PolisyAsiaWeb.war -xi WEB-INF/jboss-web.xml
zip -u PolisyAsiaWeb.war -xi WEB-INF/jboss-deployment-structure.xml
zip -d PolisyAsiaWeb.war -xi WEB-INF/classes/logback.xml
zip -u PolisyAsiaWeb.war -xi WEB-INF/classes/logback.xml

#deploy the admin in deployment folder
mv /data3/guest/integral77/target1/polisy77/deployv2/admin/PolisyAsiaWeb.war /data3/guest/integral77/target1/polisy77/jboss-eap-6.4/standalone/deployments/

#clear temp folder
rm -rf /data3/guest/integral77/target1/polisy77/jboss-eap-6.4/standalone/tmp

######################BatchJob#################################
#back up batchjob
mv /data3/guest/integral77/target1/polisy77/batchjob/csc-smart400-batch /data3/guest/integral77/target1/polisy77/backup/Latest/
#copy latest bachjob from builds folder to deployv2/batch
mv /data3/guest/integral77/target1/polisy77/builds/Latest/csc-smart400-batch.zip /data3/guest/integral77/target1/polisy77/deployv2/batch/
#cd in batch folder
cd /data3/guest/integral77/target1/polisy77/deployv2/batch/
#unzip batch
unzip csc-smart400-batch.zip
#config updates

###############temp chnages ----updating ojdbc7-12.1.0.2.jar--- until target#1 upgrade to 12C DB ##############
rm -f csc-smart400-batch/lib/ojdbc7-12.1.0.2.jar
sleep 5
cp lib/ojdbc7-12.1.0.2.jar csc-smart400-batch/lib/
sleep 5
################temp change ends here ################

zip -d csc-smart400-batch/csc-smart400-batch-1.0-SNAPSHOT.jar logback.xml
zip -u csc-smart400-batch/csc-smart400-batch-1.0-SNAPSHOT.jar logback.xml
#deploy the batch in bachjob folder
mv /data3/guest/integral77/target1/polisy77/deployv2/batch/csc-smart400-batch /data3/guest/integral77/target1/polisy77/batchjob/
#remove zipped batch
rm -f csc-smart400-batch.zip
sleep 5

#start batchjob
/data3/guest/integral77/target1/polisy77/scripts/pnc77_startbatch.sh
sleep 5

#########################MBRDATA############################
#copy the latest MBRDATA to deployv2/data
mv /data3/guest/integral77/target1/polisy77/builds/Latest/MBRDATA.war /data3/guest/integral77/target1/polisy77/deployv2/data/
#cd in data
cd /data3/guest/integral77/target1/polisy77/deployv2/data/
# config updates
zip -d MBRDATA.war -xi WEB-INF/web.xml
zip -d MBRDATA.war -xi WEB-INF/classes/config/MBRDATA.properties
zip -u MBRDATA.war -xi WEB-INF/web.xml
zip -u MBRDATA.war -xi WEB-INF/jboss-deployment-structure.xml
zip -u MBRDATA.war -xi WEB-INF/jboss-web.xml
zip -u MBRDATA.war -xi WEB-INF/classes/logback.xml
zip -u MBRDATA.war -xi WEB-INF/classes/config/MBRDATA.properties

#deploy the admin in deployment folder
mv /data3/guest/integral77/target1/polisy77/deployv2/data/MBRDATA.war /data3/guest/integral77/target1/polisy77/jboss-eap-6.4/standalone/deployments/
sleep 5

#start polisy-admin
/data3/guest/integral77/target1/polisy77/scripts/pnc77_start.sh
sleep 10

###############################################################

#rename the Latest backup folder 
mv /data3/guest/integral77/target1/polisy77/backup/Latest/ /data3/guest/integral77/target1/polisy77/backup/`date +%d-%m-%y.%H:%M:%S`

#create Latest folder inside backups
mkdir /data3/guest/integral77/target1/polisy77/backup/Latest
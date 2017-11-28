/data2/dev_env/jdk/jdk1.8.0_60/bin/java -d64 -Xms1024m -Xmx3g -XX:MaxPermSize=512m -Doracle.jdbc.autoCommitSpecCompliant=false -jar \
/data3/guest/integral77/target1/group77/batchjob/csc-smart400-batch/csc-smart400-batch-1.0-SNAPSHOT.jar \
/data3/guest/integral77/target1/group77/conf/QuipozCfg.xml &
echo $! > /data3/guest/integral77/target1/group77/batchjob/group77_batch.pid


/data2/dev_env/jdk/jdk1.8.0_60/bin/java -d64 -Xms1024m -Xmx5g -Doracle.jdbc.autoCommitSpecCompliant=false -jar \
/data3/guest/integral77/target1/life77/batchjob/csc-smart400-batch/csc-smart400-batch-1.0-SNAPSHOT.jar \
/data3/guest/integral77/target1/life77/conf/QuipozCfg.xml classpath*:com/customeraa/customerAA-services.xml &
echo $! > /data3/guest/integral77/target1/life77/batchjob/life77_batch.pid


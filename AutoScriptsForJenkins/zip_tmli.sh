#!/bin/bash
cd /home/jenkins/workspace/TMLI/CSCSmart400Batch/target/
rm -f csc-smart400-batch.zip
zip -r csc-smart400-batch.zip csc-smart400-batch
echo "Zipped batch job package"

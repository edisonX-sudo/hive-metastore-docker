#!/bin/sh

echo $HADOOP_HOME

#export HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
export HADOOP_CLASSPATH=${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.375.jar:${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-${HADOOP_VERSION}.jar
export JAVA_HOME=/usr/local/openjdk-8

echo $HADOOP_HOME

/envsubst < ${HIVE_HOME}/conf/metastore-site.xml > ${HIVE_HOME}/conf/tmp && mv ${HIVE_HOME}/conf/tmp ${HIVE_HOME}/conf/metastore-site.xml

#/opt/hadoop-3.2.0/sbin/start-dfs.sh
/opt/metastore/bin/schematool -initSchema -dbType mysql
/opt/metastore/bin/start-metastore

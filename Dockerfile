FROM openjdk:8u292-jre

WORKDIR /opt

ENV HADOOP_VERSION=3.2.1 \
    METASTORE_VERSION=3.1.2
ENV ORIGINAL_HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION} \
    ORIGINAL_HIVE_HOME=/opt/apache-hive-metastore-${METASTORE_VERSION}-bin \
    HADOOP_HOME=/opt/hadoop \
    HIVE_HOME=/opt/metastore \
    JDBC_URL="" \
    JDBC_USER="" \
    JDBC_PASS="" \
    S3_ACCESS="" \
    S3_SECRET="" \
    S3_ENDPOINT="" \
    S3_SSL_ENABLE=false \
    S3_PATH_STYLE_ACCESS=true

COPY assets /opt/

#RUN #curl -L https://repo1.maven.org/maven2/org/apache/hive/hive-standalone-metastore/${METASTORE_VERSION}/hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz | tar zxf - && \
#curl -L https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar zxf - && \
#curl -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.19.tar.gz | tar zxf - && \
RUN #tar apt-get update && apt-get install gettext
RUN tar zxf hadoop-3.2.1.tar.gz && \
tar zxf hive-standalone-metastore-3.1.2-bin.tar.gz && \
tar zxf mysql-connector-java-8.0.19.tar.gz && \
rm *.tar.gz && \
mv ${ORIGINAL_HADOOP_HOME} ${HADOOP_HOME} && \
mv ${ORIGINAL_HIVE_HOME} ${HIVE_HOME} && \
cp mysql-connector-java-8.0.19/mysql-connector-java-8.0.19.jar ${HIVE_HOME}/lib/ && \
rm -rf mysql-connector-java-8.0.19 && \
rm ${HIVE_HOME}/lib/guava-19.0.jar && \
cp ${HADOOP_HOME}/share/hadoop/common/lib/guava-27.0-jre.jar ${HIVE_HOME}/lib/ && \
cp ${HADOOP_HOME}/share/hadoop/tools/lib/hadoop-aws-${HADOOP_VERSION}.jar ${HIVE_HOME}/lib/ && \
cp ${HADOOP_HOME}/share/hadoop/tools/lib/aws-java-sdk-bundle-1.11.375.jar ${HIVE_HOME}/lib/

COPY conf ${HIVE_HOME}/conf/
COPY scripts /

RUN groupadd -r hive --gid=1000 && \
    useradd -r -g hive --uid=1000 -d ${HIVE_HOME} hive && \
    chown hive:hive -R ${HIVE_HOME} && \
    chown hive:hive -R ${HADOOP_HOME} && \
    chown hive:hive /envsubst && chmod +x /envsubst && \
    chown hive:hive /entrypoint.sh && chmod +x /entrypoint.sh && \
    chown hive:hive /wait-for-it.sh && chmod +x /wait-for-it.sh

USER root
EXPOSE 9083
#EXPOSE 9000

ENTRYPOINT ["bash", "-c", "/entrypoint.sh"]

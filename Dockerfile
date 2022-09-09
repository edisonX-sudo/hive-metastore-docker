FROM openjdk:8u242-jre

WORKDIR /opt

ENV HADOOP_VERSION=3.2.0
ENV METASTORE_VERSION=3.1.2

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HIVE_HOME=/opt/apache-hive-metastore-${METASTORE_VERSION}-bin

RUN curl -L https://repo1.maven.org/maven2/org/apache/hive/hive-standalone-metastore/${METASTORE_VERSION}/hive-standalone-metastore-${METASTORE_VERSION}-bin.tar.gz | tar zxf -
RUN curl -L https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar zxf -
RUN curl -L https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.19.tar.gz | tar zxf -
RUN cp mysql-connector-java-8.0.19/mysql-connector-java-8.0.19.jar ${HIVE_HOME}/lib/
RUN rm -rf  mysql-connector-java-8.0.19

COPY conf/metastore-site.xml ${HIVE_HOME}/conf
COPY conf/metastore-log4j2.properties ${HIVE_HOME}/conf
COPY scripts/entrypoint.sh /entrypoint.sh
COPY scripts/wait-for-it.sh /wait-for-it.sh


RUN groupadd -r hive --gid=1000 && \
    useradd -r -g hive --uid=1000 -d ${HIVE_HOME} hive && \
    chown hive:hive -R ${HIVE_HOME} && \
    chown hive:hive /entrypoint.sh && chmod +x /entrypoint.sh && \
    chown hive:hive /wait-for-it.sh && chmod +x /wait-for-it.sh

USER hive
EXPOSE 9083
#EXPOSE 9000

#ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]

FROM ubuntu:24.04

ENV TOMCAT_HOME=/u01/middleware/apache-tomcat-9.0.91
ENV PATH=$PATH:$TOMCAT_HOME/bin/

RUN apt update -y
RUN apt install -y openjdk-11-jdk
RUN apt install -y curl

RUN mkdir -p /u01/middleware
WORKDIR /u01/middleware

ADD https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.91/bin/apache-tomcat-9.0.91.tar.gz .
RUN tar -xvzf apache-tomcat-9.0.91.tar.gz
RUN rm -rf apache-tomcat-9.0.91.tar.gz

COPY target/covido.war apache-tomcat-9.0.91/webapps/
COPY run.sh apache-tomcat-9.0.91/bin/ 
RUN chmod u+x apache-tomcat-9.0.91/bin/run.sh

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD curl http://localhost:8080/covido/actuator/health/liveness

ENTRYPOINT [ "apache-tomcat-9.0.91/bin/run.sh" ]
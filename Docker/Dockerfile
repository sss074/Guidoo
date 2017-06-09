FROM centos

RUN yum install -y wget
RUN wget -q -O jdk.tar.gz --no-check-certificate --no-cookies --header 'Cookie: oraclelicense=accept-securebackup-cookie' http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz
RUN tar -zxf jdk.tar.gz -C /opt
RUN alternatives --install "/usr/bin/java" "java" /opt/jdk1.8.0_121/bin/java 2000
RUN update-alternatives --set java /opt/jdk1.8.0_121/bin/java

COPY god-server-0.1-SNAPSHOT.jar .
VOLUME /myvol

ENTRYPOINT [ "sh", "-c", "java -jar god-server-0.1-SNAPSHOT.jar > /myvol/guidoo-server.log" ]
FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y openjdk-8-jdk openjfx

RUN apt-get install -y git
RUN git clone git://github.com/apache/calcite.git

RUN apt-get install -y maven
RUN cd calcite && git checkout -b calcite-1.19.0 && mvn install -DskipTests -Dcheckstyle.skip=true

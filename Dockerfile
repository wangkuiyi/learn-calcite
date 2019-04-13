FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y openjdk-8-jdk openjfx

RUN apt-get install -y git
RUN git clone git://github.com/apache/calcite.git

RUN apt-get install -y maven
RUN cd calcite && git checkout -b calcite-1.19.0 && mvn install -DskipTests -Dcheckstyle.skip=true

ENV CLASSPATH=/calcite/file/target/*:/calcite/file/target/dependencies/*:.

RUN apt-get install -y wget
RUN wget --quiet https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protoc-3.7.1-linux-x86_64.zip

RUN apt-get install -y unzip
RUN unzip -qq protoc-3.7.1-linux-x86_64.zip -d /usr/local
RUN rm protoc-3.7.1-linux-x86_64.zip

# The gRPC official site https://grpc.io/blog/installation requires me
# to use Maven.  I don't like to learn something I don't really need.
# Thanks to this answer https://stackoverflow.com/a/53982507/724872, I
# learned where to find the protoc plugin that generates Java gRPC
# stubs.
#
# To translate CalciteParser.proto into CalciteParser.java and
# CalciteParserGrpc.java, we run the following command in the
# container:
#
#   protoc --grpc-java_out=. CalciteParser.proto
#
RUN wget --quiet http://central.maven.org/maven2/io/grpc/protoc-gen-grpc-java/1.19.0/protoc-gen-grpc-java-1.19.0-linux-x86_64.exe
RUN mv protoc-gen-grpc-java-1.19.0-linux-x86_64.exe /usr/local/bin/protoc-gen-grpc-java
RUN chmod +x /usr/local/bin/protoc-gen-grpc-java

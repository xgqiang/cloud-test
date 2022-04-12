#FROM java:11
FROM openjdk:11 as build
VOLUME /tmp
COPY target/node2-0.0.1-SNAPSHOT.jar node2.jar
ENTRYPOINT ["java","-jar","node2.jar"]
EXPOSE 7720
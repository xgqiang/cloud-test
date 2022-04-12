#FROM java:11
FROM openjdk:11 as build
VOLUME /tmp
COPY target/node1-0.0.1-SNAPSHOT.jar node1.jar
ENTRYPOINT ["java","-jar","node1.jar"]
EXPOSE 7710
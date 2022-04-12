#FROM java:11
FROM openjdk:11 as build
VOLUME /tmp
COPY target/node3-0.0.1-SNAPSHOT.jar node3.jar
ENTRYPOINT ["java","-jar","node3.jar"]
EXPOSE 7730
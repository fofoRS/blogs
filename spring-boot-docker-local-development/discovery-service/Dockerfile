# syntax=docker/dockerfile:1
FROM eclipse-temurin:17-jdk-jammy as base
WORKDIR ./app
COPY .mvn .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:resolve
COPY src ./src

FROM base as build
RUN ./mvnw package

FROM eclipse-temurin:17-jdk-jammy as production
COPY --from=build /app/target/discovery-service-*.jar /discovery-service.jar
CMD ["java", "-jar","discovery-service.jar"]

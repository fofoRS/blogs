FROM eclipse-temurin:17-jdk-jammy as base
WORKDIR ./app
COPY .mvn .mvn
COPY mvnw pom.xml ./
COPY src ./src
RUN --mount=type=cache,target=./m2 \
    ./mvnw clean package -DskipTests


FROM eclipse-temurin:17-jdk-jammy as local-development
COPY --from=base /app/target/event-collector-*.jar /event-collector.jar
EXPOSE 8081
CMD ["java", "-jar","-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8000","event-collector.jar"]
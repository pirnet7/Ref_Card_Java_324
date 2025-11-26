# Multi-stage build for Spring Boot application
# Stage 1: Build the application
FROM maven:3.8.6-eclipse-temurin-17 AS build
WORKDIR /app
 
# Copy pom.xml first to leverage Docker layer caching
# This layer will only be rebuilt if pom.xml changes
COPY pom.xml .
RUN mvn dependency:go-offline -B
 
# Copy source code and build
COPY src ./src
RUN mvn clean package -DskipTests -B
 
# Stage 2: Run the application
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app/target/app-refcard-01-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

# ---- Stage 1: The Builder (No changes here) ----
FROM maven:3.8.5-openjdk-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn package -DskipTests

# ---- Stage 2: The Final Image (This is the important change) ----
# Use the much smaller Alpine-based JRE
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
# Copy the application JAR from the builder stage
COPY --from=builder /app/target/*.jar app.jar
# Set the command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
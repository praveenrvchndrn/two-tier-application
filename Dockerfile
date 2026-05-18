# Stage 1 — Build
FROM maven:3.9-eclipse-temurin-21 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -q          # cache deps layer
COPY src ./src
RUN mvn package -DskipTests -q

# Stage 2 — Runtime (lean JRE image)
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/two-tier-app-1.0.0.jar app.jar

EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]

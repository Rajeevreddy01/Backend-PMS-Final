FROM maven:3.9.6-eclipse-temurin-17-alpine AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B -q
COPY src ./src
RUN mvn package -DskipTests -B -q

FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
RUN addgroup -S pms && adduser -S pms -G pms
COPY --from=build /app/target/*.jar app.jar
USER pms
# Render injects PORT env var (usually 10000); EXPOSE is documentation only
EXPOSE 10000
ENTRYPOINT ["java", "-Xmx400m", "-Xms256m", "-Djava.security.egd=file:/dev/./urandom", "-jar", "app.jar"]

FROM openjdk:8u232-jre
ARG JAR_PATH="dist"
ADD $JAR_PATH/app-*.jar app.jar
ENV JAVA_TOOL_OPTIONS=""
EXPOSE 8080
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app.jar"]

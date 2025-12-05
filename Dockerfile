# Use a Java runtime
FROM openjdk:17.0.2-jdk

# Create work directory inside the container
WORKDIR /opt/app

# Copy the built JAR  into the image
COPY build/libs/*.jar app.jar

# The app usually runs on 8080 (Spring Boot / typical Java web app)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]


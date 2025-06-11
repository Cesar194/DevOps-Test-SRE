# Use a base image with Java 17
FROM openjdk:17-slim

# Set the working directory
WORKDIR /app

# Copy the compiled JAR file from the target directory
COPY target/*.jar app.jar

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

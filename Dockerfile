# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jdk-slim as build

# Set the working directory in the Docker image
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Use Maven Wrapper to build the project
RUN ./mvnw clean package

# Use OpenJDK for running the application
FROM openjdk:11-jre-slim

# Copy the jar file from the build stage to the /app directory
COPY --from=build /app/target/*.jar /app/app.jar

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run the jar file 
ENTRYPOINT ["java","-jar","/app/app.jar"]

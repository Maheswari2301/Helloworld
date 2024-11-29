# Use an official Maven image to build the project
FROM maven:3.8.6-openjdk-11 AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and the source code to the container
COPY pom.xml .

# Download the dependencies (this will cache dependencies if no changes in pom.xml)
RUN mvn dependency:go-offline

# Copy the entire source code to the container
COPY src /app/src

# Build the project (this will generate the JAR file)
RUN mvn clean package -DskipTests

# Use an OpenJDK image to run the application
FROM openjdk:11-jre-slim

# Set the working directory inside the container for the runtime environment
WORKDIR /app

# Copy the JAR file from the build stage to the runtime image
COPY --from=builder /app/target/frstmaaven-1.0-SNAPSHOT.jar /app/frstmaaven.jar

# Expose the port the app will run on (if it's a web service)
EXPOSE 8080

# Command to run the JAR file
ENTRYPOINT ["java", "-jar", "frstmaaven.jar"]

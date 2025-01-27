FROM openjdk:17-slim

WORKDIR /app

RUN apt-get update && apt-get install -y git maven ca-certificates && rm -rf /var/lib/apt/lists/*

COPY .ssh/id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
RUN git clone git@github.com:daenis-dev/checkers-antivirus-api.git .

RUN mvn clean install -DskipTests

COPY certs/checkers-api.p12 /app
COPY certs/server.crt /app/server.crt

USER root
RUN chmod 777 /app/checkers-api.p12
RUN chmod 777 /app/server.crt
RUN keytool -importcert -file /app/server.crt -alias keycloak-server -cacerts -storepass changeit -noprompt -v
USER 1000

EXPOSE 8080

CMD ["java", "-Dkeystore-path=/app/checkers-api.p12", "-Dkeystore-password=changeit", "-Ddatabase-url=jdbc:postgresql://checkers-db:5432/checkers", "-Ddatabase-username=postgres", "-Ddatabase-password=changeitdb", "-Dkeycloak-admin-username=auth-admin", "-Dkeycloak-admin-password=changeit", "-Dkeycloak-checkers-uuid=2fc108f7-7aa3-4848-a875-5b96de059c1d", "-jar", "target/checkers-api-1.0-SNAPSHOT.jar"]

FROM openjdk:17-slim

WORKDIR /app

RUN apt-get update && apt-get install -y git maven ca-certificates && rm -rf /var/lib/apt/lists/*

COPY .ssh/id_rsa /root/.ssh/id_rsa
RUN chmod 600 /root/.ssh/id_rsa

RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config
RUN git clone git@github.com:daenis-dev/bizhub-api.git .

RUN mvn clean install -DskipTests

COPY certs/bizhub-api.p12 /app
COPY certs/server.crt /app/server.crt

USER root
RUN mkdir /app/storage
RUN chmod 777 /app/bizhub-api.p12
RUN chmod 777 /app/server.crt
RUN chmod 777 /app/storage
RUN keytool -importcert -file /app/server.crt -alias keycloak-server -cacerts -storepass changeit -noprompt -v
USER 1000

EXPOSE 8080

CMD ["java", "-Dserver.ssl.key-store=/app/bizhub-api.p12", "-Dserver.ssl.key-store-password=changeit", "-Dserver.ssl.key-store-type=pkcs12", "-Dserver.ssl.key-alias=bizhub-api", "-Dserver.ssl.key-password=changeit", "-Dhibernate.dialect=org.hibernate.dialect.PostgreSQLDialect", "-Dspring.datasource.url=jdbc:postgresql://bizhub-db:5432/bizhub", "-Dspring.datasource.username=postgres", "-Dspring.datasource.password=changeitdb", "-Dspring.jpa.hibernate.ddl-auto=none", "-Dkeycloak.admin.username=auth-admin", "-Dkeycloak.admin.password=changeit", "-Dkeycloak-admin-client-name=admin-cli", "-Dkeycloak-bizhub-uuid=2fc108f7-7aa3-4848-a875-5b96de059c1d", "-Dspring.profiles.active=dev", "-Djwt-issuer-uri=https://keycloak-server:9880/realms/bizhub", "-Djwk-set-uri=https://keycloak-server:9880/realms/bizhub/protocol/openid-connect/certs", "-Dclient-id=bizhub_api", "-Dkeycloak-base-url=https://keycloak-server:9880", "-Dkeycloak-bizhub-base-url=https://keycloak-server:9880/admin/realms/bizhub", "-Dkeycloak-bizhub-login-url=https://keycloak-server:9880/realms/bizhub/protocol/openid-connect/token", "-Dkeycloak-bizhub-token-schema=bearer", "-jar", "target/bizhub-api-1.0-SNAPSHOT.jar"]
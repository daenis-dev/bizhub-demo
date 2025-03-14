FROM debian:bullseye-slim AS builder

RUN apt-get update && apt-get install -y \
    ca-certificates \
    openjdk-17-jre-headless \
    && rm -rf /var/lib/apt/lists/*

FROM quay.io/keycloak/keycloak:26.0.4

COPY certs/server.p12 /opt/keycloak/conf/server.p12
COPY conf/bizhub-realm.json /opt/keycloak/data/import/realm.json
COPY certs/bizhub-api.crt /app/bizhub-api.crt

USER root
RUN chown keycloak:keycloak /opt/keycloak/conf/server.p12
RUN chown keycloak:keycloak /app/bizhub-api.crt
RUN keytool -importcert -file /app/bizhub-api.crt -alias bizhub-api -cacerts -storepass changeit -noprompt -v

USER keycloak

EXPOSE 9880

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start", "--import-realm"]

# https://github.com/Pugmatt/BedrockConnect/blob/8e0d78e8619d106079a7cfa165e6e4695031bdbe/docker/Dockerfile
FROM openjdk:11
RUN mkdir -p /docker/brc
ADD https://github.com/Pugmatt/BedrockConnect/releases/latest/download/BedrockConnect-1.0-SNAPSHOT.jar /docker/brc
WORKDIR /docker/brc
EXPOSE 19132/udp
CMD ["java", "-Xms256M", "-Xmx256M", "-jar", "BedrockConnect-1.0-SNAPSHOT.jar", "nodb=true"]

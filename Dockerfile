FROM debian:bullseye-slim
WORKDIR /opt/
RUN apt-get update && apt-get install -y openjdk-17-jre-headless wget && apt-get clean
COPY setup.sh /opt/
ENV MEMORY=1G
ENV VERSION=1.18.2
ENTRYPOINT ["/bin/sh", "setup.sh"]
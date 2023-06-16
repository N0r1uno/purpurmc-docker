FROM eclipse-temurin:19-jre
WORKDIR /opt/
COPY setup.sh backup.sh /opt/
ENV VERSION=1.20.1
ENV MEMORY=2G
ENV BACKUP=30m
ENV INCUBATOR=true
ENTRYPOINT ["./setup.sh"]
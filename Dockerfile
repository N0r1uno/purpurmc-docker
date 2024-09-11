FROM eclipse-temurin:21-jre
WORKDIR /opt/
ENV VERSION=1.21.1
ENV MEMORY=4G
ENV INCUBATOR=true
COPY setup.sh /opt/
ENTRYPOINT ["./setup.sh"]
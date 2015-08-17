FROM  jboss/base-jdk:7

EXPOSE 8081

ENV NEXUS_VERSION 2.11.4-01

# Install the binaries
RUN cd $HOME \
   && curl https://sonatype-download.global.ssl.fastly.net/nexus/oss/nexus-$NEXUS_VERSION-bundle.tar.gz | tar xz \ 
   && mv nexus-$NEXUS_VERSION nexus
   && mkdir /opt/jboss/sonatype-work && mkdir /opt/jboss/repositories && chmod -R o+w

ENV NEXUS_WORK /opt/jboss/sonatype-work
VOLUME ["/opt/jboss/sonatype-work"]

ENV NEXUS_DATA /opt/jboss/repositories
VOLUME ["/opt/jboss/repositories"]


# Define the entrypoint and cmd.
ENTRYPOINT ["/opt/jboss/nexus/bin/nexus"]
CMD ["console"]

LABEL run docker run -it --rm --volumes-from nexus-data --name nexus-server -p 8081:8081 nexus-server

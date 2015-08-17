FROM  jboss/base-jdk:7

EXPOSE 8081

ENV NEXUS_VERSION 2.11.4-01
ENV NEXUS_WORK /opt/jboss/sonatype-work
ENV NEXUS_DATA /opt/jboss/repositories
LABEL run docker run -it --rm --volumes-from nexus-data --name nexus-server -p 8081:8081 nexus-server


# Install the binaries
RUN cd $HOME \
   && curl https://sonatype-download.global.ssl.fastly.net/nexus/oss/nexus-$NEXUS_VERSION-bundle.tar.gz | tar xz \ 
   && mv nexus-$NEXUS_VERSION nexus \ 
   && mkdir -p {$NEXUS_WORK,$NEXUS_DATA} && chmod -R o+w $HOME \
   && chmod g+x $HOME/nexus/bin/nexus

COPY scripts/readinessProbe.sh /usr/local/bin/readinessProbe.sh
USER root
RUN chown jboss:jboss /usr/local/bin/readinessProbe.sh && chmod 777 /usr/local/bin/readinessProbe.sh
USER jboss

VOLUME ["/opt/jboss/sonatype-work"]
VOLUME ["/opt/jboss/repositories"]

# Define the entrypoint and cmd.
ENTRYPOINT ["/opt/jboss/nexus/bin/nexus"]
CMD ["console"]

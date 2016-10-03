# https://github.com/sonatype/docker-nexus3
FROM docker.io/sonatype/nexus3:3.0.2

USER root

# Copy scripts and json config
COPY usr/local/bin/ /usr/local/bin/
COPY opt/sonatype/nexus/etc /opt/sonatype/nexus/etc

# 1. Install wget/jq - used /usr/local/bin/*.sh
# 2. Fix permissions
RUN yum install -y wget \
  && yum clean all \
  && curl --fail --silent --location --retry 3 https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /usr/local/bin/jq \
  && /usr/local/bin/fix-permissions.sh /usr/local/bin \
  && /usr/local/bin/fix-permissions.sh /opt/sonatype \
  && chmod 775 /usr/local/bin/* \
  && chown nexus:nexus /usr/local/bin/* \
  && chown -R nexus:nexus /opt/sonatype

# switch to nexus
USER 200

CMD ["/opt/sonatype/nexus/bin/nexus", "run"]

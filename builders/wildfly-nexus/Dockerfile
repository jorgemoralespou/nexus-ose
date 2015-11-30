FROM docker.io/openshift/wildfly-81-centos7:latest

# Add jq, to enable to manipulate json files
RUN curl http://stedolan.github.io/jq/download/linux64/jq -o /tmp/jq && chmod 755 /tmp/jq

# This could be done with a cron in an SPC container with LABEL to install in systemd (RHEL7 or docker 1.6 required)
COPY scripts/addrepo.sh /tmp/addrepo.sh

# Copy the STI scripts from the specific language image to /usr/local/sti
COPY ./.sti/bin/ $STI_SCRIPTS_PATH

COPY settings.xml /usr/local/m2/

FROM docker.io/openshift/wildfly-81-centos7:latest

# Copy the STI scripts from the specific language image to /usr/local/sti
COPY ./.sti/bin/ /usr/local/sti

COPY settings.xml /usr/local/m2/

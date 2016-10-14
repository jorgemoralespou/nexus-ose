#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z NEXUS_BASE_URL ]
then
   export NEXUS_BASE_URL="http://localhost:8081"
fi

${DIR}/nexusscript-create.sh /opt/sonatype/nexus/etc/jboss-public-repo.json
${DIR}/nexusscript-create.sh /opt/sonatype/nexus/etc/redhat-techpreview-all-repo.json
${DIR}/nexusscript-create.sh /opt/sonatype/nexus/etc/redhat-ga-repo.json
${DIR}/nexusscript-create.sh /opt/sonatype/nexus/etc/redhat-group-repo.json

${DIR}/nexusscript-run.sh jboss-public-repo
${DIR}/nexusscript-run.sh redhat-techpreview-all-repo
${DIR}/nexusscript-run.sh redhat-ga-repo
${DIR}/nexusscript-run.sh redhat-group-repo

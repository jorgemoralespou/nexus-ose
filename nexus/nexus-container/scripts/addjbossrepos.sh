#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

${DIR}/addrepo.sh jboss-ga       https://maven.repository.redhat.com/ga/
${DIR}/addrepo.sh jboss-ea       https://maven.repository.redhat.com/earlyaccess/all/
${DIR}/addrepo.sh jboss-ce       https://repository.jboss.org/nexus/content/groups/public/
${DIR}/addrepo.sh jboss-techprev https://maven.repository.redhat.com/techpreview/all

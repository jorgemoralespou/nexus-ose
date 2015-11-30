#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

${DIR}/addrepo.sh jboss http://maven.repository.redhat.com/techpreview/all/
${DIR}/addrepo.sh jboss-ce https://repository.jboss.org/nexus/content/groups/public/

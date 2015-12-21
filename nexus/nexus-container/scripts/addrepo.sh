#!/bin/sh
#
# Sonatype nexus Rest API: https://oss.sonatype.org/nexus-restlet1x-plugin/default/docs/index.html
#
# addrepo.sh jboss http://maven.repository.redhat.com/techpreview/all/
# addrepo.sh jboss-ce https://repository.jboss.org/nexus/content/groups/public/
#
TEMPLATE_FILE="/tmp/repo.json"

: ${NEXUS_USER:="admin"}
: ${NEXUS_PASSWORD:="admin123"}
: ${NEXUS_BASE_URL:="http://localhost:8081"}

read -d '' TEMPLATE << EOF
{
   "data": {
      "repoType": "proxy",
      "id": "%ID%",
      "name": "%ID%",
      "browseable": true,
      "indexable": true,
      "notFoundCacheTTL": 1440,
      "artifactMaxAge": -1,
      "metadataMaxAge": 1440,
      "itemMaxAge": 1440,
      "repoPolicy": "RELEASE",
      "provider": "maven2",
      "providerRole": "org.sonatype.nexus.proxy.repository.Repository",
      "downloadRemoteIndexes": true,
      "autoBlockActive": true,
      "fileTypeValidation": true,
      "exposed": true,
      "checksumPolicy": "WARN",
      "remoteStorage": {
         "remoteStorageUrl": "%REPO%",
         "authentication": null,
         "connectionSettings": null
      }
   }
}
EOF


function usage {
   echo "You have to pass a repo ID and a remote repo URL"
}

[ "$#" -ne 2 ] && usage && exit 0

repoID=$1
repoURL=$2
# Verify that nexus server is running on port 8081 internally, otherwise fail
# TODO:

function sedeasy {
  echo "sed -i \"s/$(echo $1 | sed -e 's/\([[\/.*]\|\]\)/\\&/g')/$(echo $2 | sed -e 's/[\/&]/\\&/g')/g\" $3"
  sed -i "s/$(echo $1 | sed -e 's/\([[\/.*]\|\]\)/\\&/g')/$(echo $2 | sed -e 's/[\/&]/\\&/g')/g" $3
}

# This function will load into http://localhost:8081/nexus the appropriate configuration
# and extract the zip file into the data_volume_container
# 
# Arguments:
#    repoID
#    repoURL
#
function loadRepo {
   local _id=$1
   local _url=$2
   local _exit=0 

   # Replace the ID token with the name of the zip file (without .zip) and replace in template
   echo "$TEMPLATE" > $TEMPLATE_FILE
   sedeasy "%ID%" "$_id" $TEMPLATE_FILE
   sedeasy "%REPO%" "$_url" $TEMPLATE_FILE

   echo "Sending the following template for creating repo $_id"
   cat $TEMPLATE_FILE

   # Create repository configuration
   curl -H "Accept: application/json" -H "Content-Type: application/json" -f -X POST  -v -d "@$TEMPLATE_FILE" -u "${NEXUS_USER}:${NEXUS_PASSWORD}" "${NEXUS_BASE_URL}/service/local/repositories"

   # TODO: Instead of failing, check if the repository exist.
   _exit=$?
   [ $_exit -ne 0 ] && echo "Error creating the hosted repository for $_id" && exit $_exit 

   # Adding repository configuration to public group.
   # We first query for current config and write it into a /tmp/group.json file
   curl -s -H "Accept: application/json" -H "Content-Type: application/json" -f -X GET -u "${NEXUS_USER}:${NEXUS_PASSWORD}" -o /tmp/group.json "${NEXUS_BASE_URL}/service/local/repo_groups/public"
   [ $_exit -ne 0 ] && echo "Error getting public group repository information" && exit $_exit 

   # then we add repository id
   /tmp/jq '.' /tmp/group.json > /tmp/group-pretty.json
   sed -i -e "`wc -l /tmp/group-pretty.json | awk '{s=$1-3} END {print s}'` a\,{\"id\":\"$_id\"}" /tmp/group-pretty.json

   [ ! -f /tmp/group-pretty.json ] && echo "Something failed while trying to add the repository to the public group. Do it manually" && exit 2
   # and we load the new configuration for public group
   curl -H "Accept: application/json" -H "Content-Type: application/json" -f -X PUT  -v -d "@/tmp/group-pretty.json" -u "${NEXUS_USER}:${NEXUS_PASSWORD}" "${NEXUS_BASE_URL}/service/local/repo_groups/public"
   [ $_exit -ne 0 ] && echo "Error adding the hosted repository for $_id to the public group" && exit $_exit 

   echo "------"
   echo "------"
   echo "------"
   echo "Repository loaded with name $_id and added into public group"
   echo "------"
   echo "------"
   echo "------"
}


echo "Loading $repoID hosting $repoURL"
loadRepo "$repoID" "$repoURL" 

#!/bin/bash

# TODO: deal with no previous pipeline / null coverage value

# get coverage for latest current pipeline
#tmp=`curl -s https://gitlab.com/api/v4/projects/${CI_PROJECT_ID}/pipelines/ | jq '.[0] | .id'`

latest=`curl -s https://gitlab.com/api/v4/projects/${CI_PROJECT_ID}/pipelines/${CI_PIPELINE_ID} | jq '.coverage'`

latest="${latest%\"}"
latest="${latest#\"}"
latest="${latest/.*}"
echo "pipline " ${CI_PIPELINE_ID} " coverage value = " $latest

# get coverage for master
tmp=`curl -s https://gitlab.com/api/v4/projects/${CI_PROJECT_ID}/pipelines\?ref\=master\&status\=success | jq '.[0] | .id'`

# pass that into the curl below
master=`curl -s https://gitlab.com/api/v4/projects/${CI_PROJECT_ID}/pipelines/${tmp} | jq '.coverage'`
echo "master coverage = " $master
master="${master%\"}"
master="${master#\"}"
master="${master/.*}"
echo "master coverage value =" $master

# if latest >= master exit 0
if [ "$latest" -ge "$master" ]
then
  echo "Latest pipeline coverage >= master"
  exit 0
# else exit 1
else
  echo "Latest pipeline coverage < master"
  exit 1
fi

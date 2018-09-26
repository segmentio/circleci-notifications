#!/bin/bash

# Send a notification to Slack when a build on a particular branch fails.
# This is a workaround for CircleCI 2.0's lack of branch-specific notification settings.

# Usage: BUILD_STATUS="Failed|Succeeded" [NOTIFY_BRANCH="important-branch"] branch-notification
# Add this as an on_fail or on_success step in the CircleCI config file.
# A Slack webhook has to be configured in the CircleCI project, with name $SLACK_WEBHOOK_URL
# Eg:
#      - run:
#          name: Build Failed
#          when: on_fail
#          command: BUILD_STATUS="Failed" NOTIFY_BRANCH="v3.0" branch-notification.sh

set -e

# default notification for master branch if not specified
if [ -z ${NOTIFY_BRANCH} ]; then
    NOTIFY_BRANCH="master"
fi

message="{\"text\": \"*${BUILD_STATUS}*: build <${CIRCLE_BUILD_URL}|#${CIRCLE_BUILD_NUM}> in *${CIRCLE_PROJECT_REPONAME}* (_${CIRCLE_BRANCH}_:${CIRCLE_SHA1})\"}"

if [ ${CIRCLE_BRANCH} == ${NOTIFY_BRANCH} ] ; then
    curl -X POST -H 'Content-type: application/json' --data "${message}" ${SLACK_WEBHOOK_URL}
fi

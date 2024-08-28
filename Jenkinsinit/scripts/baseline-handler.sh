#!/usr/bin/env bash
set -e
set -x
cmd=$1
DOCKER=docker
GIT_TAG_ENABLED="false"

case $cmd in
    prepare)
        echo "Start prepare command"
        ;;
    publish)
        echo "Start publish command"
        GIT_TAG_ENABLED="true"
        ;;
    dryrun)
        echo "Start dryrun"
        DOCKER="echo docker "
        ;;
    *)
        echo "Invalid parameter: '$cmd', must provide: prepare or publish"
        exit 1
        ;;
esac

if [ -z "$cmd" ]; then
    echo "Must provide command: prepare or publish"
    exit 1
fi

IMAGE=armdocker.rnd.ericsson.se/proj-adp-cicd-drop/adp-int-helm-chart-auto:0.4.0-131
HELM_REPO_INT="https://arm.sero.gic.ericsson.se/artifactory/proj-bdgs-cn-app-mgmt-ci-internal-helm/"
HELM_REPO_DRP="https://arm.sero.gic.ericsson.se/artifactory/proj-bdgs-cn-app-mgmt-drop-helm/"
HELM_REPO_REL="https://arm.sero.gic.ericsson.se/artifactory/proj-bdgs-cn-app-mgmt-released-helm/"
HELM_USERNAME="amadm100"
DEMO_GIT="https://gerrit.ericsson.se/a/OSS/com.ericsson.orchestration.mgmt/cn-app-mgmt-integration-chart"
DEMO_CHART_PATH="eric-cn-app-mgmt-integration"
DEMO_BRANCH="master"
$DOCKER pull ${IMAGE} || true
$DOCKER inspect ${IMAGE} -f '{{range $key, $value := .Config.Labels}}{{printf "%s: %s\n" $key $value}}{{end}}' || true

echo
echo $CHART_NAME
echo $CHART_REPO
echo $CHART_VERSION
$DOCKER run --init --rm --user $(id -u):$(id -g) \
  --env CHART_NAME \
  --env CHART_REPO \
  --env CHART_VERSION \
  --env GERRIT_REFSPEC \
  --env GERRIT_USERNAME \
  --env GERRIT_PASSWORD \
  --env GIT_BRANCH=${DEMO_BRANCH} \
  --env HELM_REPO_CREDENTIALS=/tmp/helm-repositories-file \
  --env ARM_API_TOKEN \
  --env GIT_REPO_URL=${DEMO_GIT} \
  --env CHART_PATH=${DEMO_CHART_PATH} \
  --env HELM_INTERNAL_REPO=${HELM_REPO_INT} \
  --env HELM_DROP_REPO=${HELM_REPO_DRP} \
  --env HELM_RELEASED_REPO=${HELM_REPO_REL} \
  --env ALLOW_DOWNGRADE="false" \
  --env IGNORE_NON_RELEASED="false" \
  --env AUTOMATIC_RELEASE="true" \
  --env ALWAYS_RELEASE="false" \
  --env SKIP_COND \
  --env SOURCE=${JENKINS_URL}/job/${JOB_NAME}/${BUILD_NUMBER} \
  --env GERRIT_TOPIC="inca" \
  --env UPLOAD_INTERNAL \
  --env GIT_TAG_ENABLED=${GIT_TAG_ENABLED} \
  --volume $WORKSPACE:$WORKSPACE \
  --volume $HELM_REPO_CREDENTIALS:/tmp/helm-repositories-file:ro \
  --workdir $WORKSPACE ${IMAGE} \
  ihc-auto $cmd

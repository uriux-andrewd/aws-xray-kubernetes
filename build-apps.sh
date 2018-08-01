#!/bin/bash

########
#
# build-apps.sh
# 
#usage: build.apps.sh version
# Rebuilds the containers locally, pushes them to docker repo, and deploys them using the deployment templates.
# Configure using app.conf
#
#
#########




DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source  ${DIR}/app.conf

function dockerLogin() { echo -e "Logging into docker with uriuxaks username..\n";docker login -u "${DOCKER_USERNAME}" -p"${DOCKER_PASSWORD}"; }







function getAppDeployment () {

# Read the Template
APP_TEMPLATE=$(cat  <(cat ${DIR}/demo-app/k8s-deploy.yaml))


# Replace Placholders with Configured Values
APP_TEMPLATE=$(cat  <(sed 's|IMAGE_TAG|'"${APP_VERSION}"'|g'  <(echo "${APP_TEMPLATE}")))
APP_TEMPLATE=$(cat  <(sed 's|APP_REPO_A|'"${APP_REPO_A}"'|g'  <(echo "${APP_TEMPLATE}")))
APP_TEMPLATE=$(cat  <(sed 's|APP_REPO_B|'"${APP_REPO_B}"'|g'  <(echo "${APP_TEMPLATE}")))

echo -e "${APP_TEMPLATE}"
}

function getDaemonDeployment () {

# Read the Template
DAEMON_TEMPLATE=$(cat  <(cat ${DIR}/xray-daemon/xray-k8s-daemonset.yaml))

# Replace Placholders with Configured Values
DAEMON_TEMPLATE=$(cat  <(sed 's|DAEMON_REPO|'"${DAEMON_REPO}"'|g'  <(echo "${DAEMON_TEMPLATE}")))

# output
echo -e "${DAEMON_TEMPLATE}"
}





: ${1?"Usage: $0 Missing Version (Docker Tag), Usage: build-apps.sh version"}


	APP_VERSION=$1







	# build
	docker build -t "${APP_REPO_A}":${APP_VERSION}  ${DIR}/demo-app/service-a/
	docker build -t "${APP_REPO_B}":${APP_VERSION}  ${DIR}/demo-app/service-b/
	docker build -t "${DAEMON_REPO}":latest ${DIR}/xray-daemon/



	# container registry
	dockerLogin
	docker push "${DAEMON_REPO}":latest
	docker push "${APP_REPO_A}":${APP_VERSION}
	docker push "${APP_REPO_B}":${APP_VERSION}

	# deploy
	# kubectl apply -f ${DIR}/xray-deamon/xray-k8s-daemonset.yaml
	kubectl apply -f   <(getAppDeployment)
	kubectl apply -f   <(getDaemonDeployment)
	

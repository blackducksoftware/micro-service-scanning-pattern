#!/bin/bash

version="1"
HUB_URL=${1:-https://ec2-18-217-189-8.us-east-2.compute.amazonaws.com}
MAX_VERSIONS=${2:-2}
MAX_SCANS=${3:-10}

HUB_USERNAME=${HUB_USERNAME:-sysadmin}
HUB_PASSWORD=${HUB_PASSWORD:-blackduck}

echo "==============================================="
echo "Demo of microservice scanning model strategy 1"
echo "using version in scan/version names, but deleting"
echo "older scans/versions as you go"
echo "==============================================="
PROJECT_NAME="microservice-strategy1"
while [ ${version} -le ${MAX_SCANS} ]
do
	echo "Create a new version ${version} for project ${PROJECT_NAME}, sending output to ${version}.log"
	start_time=$(date +%s)
	detect --blackduck.url=${HUB_URL} \
		--blackduck.username=${HUB_USERNAME} \
		--blackduck.password=${HUB_PASSWORD} \
		--blackduck.trust.cert=true \
		--detect.project.name=${PROJECT_NAME} \
		--detect.project.version.name=${version} \
		--detect.code.location.name="${PROJECT_NAME}-${version}" \
		--detect.policy.check.fail.on.severities=ALL jars > ${version}.log 2>&1
	end_time=$(date +%s)
	elapsed_time_seconds=$(expr $end_time - $start_time)
	echo "Took ${elapsed_time_seconds} seconds for detect to scan and analyze version ${version}"
	echo "Check the number of versions and if greater than ${MAX_VERSIONS}, remove the oldest ones including their scans"
	python find_and_delete_older_versions.py ${PROJECT_NAME} ${MAX_VERSIONS}
	version=$(expr $version + 1)
done

echo "Done with the demo of strategy 1"

# Having trouble using the REST API to update the Nickname, so leaving this one unfinished for now
# 
# echo "==============================================="
# echo "Demo of microservice scanning model strategy 2"
# echo "overwrite previous scans/versions but update the"
# echo "version label in the Nickname field"
# echo "==============================================="
# version="1"
# PROJECT_NAME="microservice-strategy2"
# while [ ${version} -le ${MAX_SCANS} ]
# do
# 	echo "Do another scan using same scan and version name to overwrite prior one"
# 	start_time=$(date +%s)
# 	detect --blackduck.url=https://ec2-18-217-189-8.us-east-2.compute.amazonaws.com \
# 		--blackduck.username=sysadmin \
# 		--blackduck.password=blackduck \
# 		--blackduck.trust.cert=true \
# 		--detect.project.name=${PROJECT_NAME} \
# 		--detect.project.version.name=LATEST \
# 		--detect.code.location.name="${PROJECT_NAME}-LATEST" \
# 		--detect.policy.check.fail.on.severities=ALL jars > ${version}.log 2>&1
# 	end_time=$(date +%s)
# 	elapsed_time_seconds=$(expr $end_time - $start_time)
# 	echo "Took ${elapsed_time_seconds} seconds for detect to scan and analyze version ${version}"
# 	version=$(expr $version + 1)
# done

# echo "Done with the demo of strategy 2"
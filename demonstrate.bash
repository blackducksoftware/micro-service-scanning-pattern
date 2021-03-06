#!/bin/bash

#
# A script to demonstrate scanning a micro- or web-service which is being
# developed on a single branch with automated build/deployment happening off that branch
#

#
# Defaults and parameters
#
version="1"
HUB_URL=${1:-https://ec2-18-217-189-8.us-east-2.compute.amazonaws.com}
MAX_VERSIONS_TO_RETAIN=${2:-2}
NUM_VERSIONS_TO_PRODUCE=${3:-10}

HUB_USERNAME=${HUB_USERNAME:-sysadmin}
HUB_PASSWORD=${HUB_PASSWORD:-blackduck}

#
# Function to create the authentication credentials for using the Black Duck python
# library, blackduck, see 
# 		https://github.com/blackducksoftware/hub-rest-api-python
# 		https://pypi.org/project/blackduck/
#

function create_rest_config_file {
	cat > .restconfig.json <<EOF
{
   "baseurl": "${HUB_URL}",
   "username": "${HUB_USERNAME}",
   "password": "${HUB_PASSWORD}",
   "insecure": true,
   "debug": false
}	
EOF
}

create_rest_config_file

#
# For test/demo purposes, this is a list of versions that pass the tests and get pushed to production
# but the tests happen sometime after the scan and verions are created
#
versions_to_keep=(3 5 8)

echo "==============================================="
echo "Demo of microservice scanning model strategy"
echo "using version in scan/version names, but deleting"
echo "older scans/versions as you go UNLESS the version"
echo "phase is set to RELEASED or ARCHIVED"
echo "==============================================="
PROJECT_NAME="microservice-strategy"

while [ ${version} -le ${NUM_VERSIONS_TO_PRODUCE} ]
do
    clone_from_prior_version

	echo -e "Create a new version ${version} for project ${PROJECT_NAME}\n"
	python create_project_version.py ${PROJECT_NAME} ${version}

	# check if the version is in the list of those to keep, and if it is,
	# then mark it as RELEASED which also will mark any existing RELEASED
	# versions as ARCHIVED
	if [[ " ${versions_to_keep[@]} " =~ " ${version} " ]]; then
		echo -e "Setting version ${version} to RELEASED\n"
		python set_new_released_version.py ${PROJECT_NAME} ${version}
		echo ""
	fi

	# This should be run after each (new) scan/version is created
	python find_and_delete_older_versions.py ${PROJECT_NAME} ${MAX_VERSIONS_TO_RETAIN}
	echo ""
	version=$(expr $version + 1)
done

echo "Done with the demo of strategy"

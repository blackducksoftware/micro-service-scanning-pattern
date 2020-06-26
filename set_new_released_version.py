'''
Created on Jun 26, 2020

@author: gsnyder

In developing a micro-service, web-service, or SaaS application there is usually one, and only one, version
in Production. When scanning these type of projects with Black Duck it isn't necessarily known, at the time of
the scan, whether the version being scanned will become the new RELEASED version in production. That is often
not known until a point in time later, after testing has been completed.

This script allows the caller to set a version's phase (in Black Duck) to RELEASED indicating that this version
is now the one running in production. 

WARNING: At the same time the script will un-mark any other version (in this project)
that was already marked as RELEASED and mark it as ARCHIVED or a user-configurable phase. This assumes that
a micro-service, web-service, or SaaS application can have ONLY ONE VERSION RUNNING IN PRODUCTION.

NOTE: The Black Duck On-line Help has more information on how an ARCHIVED version behaves. Please review it
before using this script.

'''
import argparse
import logging
import sys

from blackduck.HubRestApi import HubInstance

parser = argparse.ArgumentParser("Set the project-version to phase=RELEASED and if there are any existing versions set to RELEASED change them to ARCHIVED")
parser.add_argument("project_name")
parser.add_argument("version_name")

args = parser.parse_args()

logging.basicConfig(format='%(asctime)s:%(levelname)s:%(module)s: %(message)s', stream=sys.stderr, level=logging.DEBUG)
logging.getLogger("requests").setLevel(logging.WARNING)
logging.getLogger("urllib3").setLevel(logging.WARNING)
logging.getLogger("blackduck").setLevel(logging.WARNING)


hub = HubInstance()

project = hub.get_project_by_name(args.project_name)
versions = hub.get_project_versions(project, limit=200).get('items', [])
version_names = [v['versionName'] for v in versions]
assert args.version_name in version_names, f"Looks like the version we are trying to set ({args.version_name}) is not in project {args.project_name} which has the following versions: {version_names}"

released_versions = list(filter(lambda v: v['phase'] == 'RELEASED', versions))
for version in released_versions:
	logging.debug(f"Marking RELEASED version {version['versionName']} phase as ARCHIVED")
	hub.update_project_version_settings(args.project_name, version['versionName'], {'phase': 'ARCHIVED'})

logging.debug(f"Marking version {args.version_name} as RELEASED")
hub.update_project_version_settings(args.project_name, args.version_name, {'phase': 'RELEASED'})

# TODO: code to generate/dump the CSV reports for the RELEASED project-version








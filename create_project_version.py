#!/usr/bin/env python

import argparse
import json
import logging
import sys

from blackduck.HubRestApi import HubInstance, object_id

parser = argparse.ArgumentParser("Create a project and version - useful for demonstrating stuff")
parser.add_argument("project_name")
parser.add_argument("version")
args = parser.parse_args()

logging.basicConfig(format='%(asctime)s:%(levelname)s:%(message)s', stream=sys.stderr, level=logging.DEBUG)
logging.getLogger("requests").setLevel(logging.WARNING)
logging.getLogger("urllib3").setLevel(logging.WARNING)

hub = HubInstance()

project_version = hub.get_or_create_project_version(args.project_name, args.version)



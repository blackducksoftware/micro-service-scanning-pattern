# Microservice Scanning Pattern Demonstration

Miro-services are characterized by:

* Development happening on one branch
* Frequently deploying new versions to production, e.g. multiple times per day
* Often, the Black Duck scan/version creation happens before it is known whether the version being analyzed will be pushed to production

This demo shows how to setup scans of mico-services to:

* Mark and retain RELEASED versions (in Black Duck) corresponding to versions that were pushed to production
* Prune/delete older, un-RELEASED (or un-ARCHIVED) versions in Black Duck

# To run the demo

- You need python3 and a virtualenv environment is highly recommended.

- You need a Hub server and it's URL

- ```bash
  pip install -r requirements.txt # will install the 'blackduck' package from PyPi
  export HUB_USERNAME=<your username>	# the script will default to 'sysadmin'
  export HUB_PASSWORD=<your password>	# the script will default to 'blackduck'
  ./demonstrate.bash
  ```

  The script will proceed to create versions similar to a stream of builds of a micro-service, web-service, or SaaS application. As the versions are created, some will be marked as RELEASED mimicking the idea that those versions were (later) pushed to production.Additionally, any (prior, now old) version that was RELEASED will be marked as ARCHIVED so that there is one, and only one, version (in the project) that is marked as RELEASED. 

  Finally, older non-RELEASED, non-ARCHIVED versions are deleted as new versions are created. 
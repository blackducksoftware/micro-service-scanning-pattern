# Microservice Scanning Pattern Demonstration

Miro-services are characterized by:

* Development happening on one branch
* Frequently deploying new versions to production, e.g. multiple times per day

This demo shows how to setup scans of mico-services to avoid proliferation of scan/version data that can lead to:

* Degraded performance of the Black Duck (Hub) system
* False positive alerts when new vulnerabilities are published (e.g. by NVD, BDSA) that point to prior scans/versions which are no longer running in production

There are two basic strategies for how to setup the scans for a micro-service:

1. Use the (rapidly changing) version of the micro-service in the Black Duck scan/version names, and then purge/delete older scans/versions as you go.
2. Do not use the (rapidly changing) version in scan/version names, instead over-write the prior scan/version each time you scan, and place the version label elsewhere in the project-version, e.g. in the Nickname field.

# To run the demo

- You need python3 and a virtualenv environment is highly recommended.

- You need a Hub server and it's URL

- ```bash
  pip install -r requirements.txt # will install the 'blackduck' package from PyPi
  export HUB_USERNAME=<your username>	# the script will default to 'sysadmin'
  export HUB_PASSWORD=<your password>	# the script will default to 'blackduck'
  ./demonstrate.bash https://hub-host
  ```

  The script will proceed to scan a jar file the comes with the repos, creating new versions (up to 10 by default) and keeping the most recent ones (2 by default).

  You can invoke the script and provide the max number of versions to keep and the maximum number of scans to perform as well, e.g.

  ```bash
  ./demonstrate.bash https://hub-host 3 5 	# keep 3 versions max, and do 5 scans
  ```

   
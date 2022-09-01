# arduino-docker
# cd <arduino-docker repo dir>

# build the image
docker build -t arduino .

# cd <arduino project dir>

# build project
docker run --rm -v ${PWD}:/workdir/project arduino /bin/bash -c '\
	cd /workdir/project && \
	arduino-cli compile -b -e SparkFun:apollo3:sfe_artemis_module project.ino'


# start as daemon / detached
docker run -d arduino bash
docker ps
docker exec -it <container id> bash

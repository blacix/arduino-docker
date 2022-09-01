# arduino-docker

## build docker image
```
cd <arduino-docker repo dir>
docker build -t arduino .
```

## build your project
```
cd <arduino project dir>

docker run --rm -v ${PWD}:/workdir/project arduino /bin/bash -c '\
	cd /workdir/project && \
	arduino-cli compile -b -e SparkFun:apollo3:sfe_artemis_module project.ino'

```

# start as daemon / detached
```
docker run -d arduino bash
docker ps
docker exec -it <container id> bash
```

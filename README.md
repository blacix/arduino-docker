# arduino-docker
Docker image for building Arduino projects.\
3rd party board support included, see `arduino-cli.yaml`.\
Arduino core SparkFun:apollo3 installed as example.\
Arduino BLE 1.3.1 with patch.\
See details in the following link:\
https://github.com/arduino-libraries/ArduinoBLE/issues/175


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
	arduino-cli compile -e -b SparkFun:apollo3:sfe_artemis_atp project.ino'
```

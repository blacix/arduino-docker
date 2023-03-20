# Base image which contains global dependencies
FROM ubuntu:20.04 as base

WORKDIR /workdir

ENV ARDUINO_VERSION="arduino-1.8.13"

# System dependencies
ARG arch=amd64
RUN apt update -y && apt upgrade -y && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
        wget \
        curl \
        xz-utils \
        ca-certificates \
        && \
    apt -y clean && apt -y autoremove && rm -rf /var/lib/apt/lists/*


# install arduino and arduino-cli
ENV PATH="/workdir/arduino/bin:${PATH}"

# Create a new user with the desired UID and GID
ARG USER_NAME=jenkins
ARG USER_ID=1000
ARG GROUP_ID=1000
RUN groupadd -g ${GROUP_ID} ${USER_NAME} && \
    useradd -u ${USER_ID} -g ${GROUP_ID} -ms /bin/bash ${USER_NAME}

# install Arduino with this user
USER ${USER_NAME}:${USER_NAME}

# create folder for Arduino library installation target - see arduino-cli.yaml
RUN mkdir /home/${USER_NAME}/Arduino

# download and install Arduino
WORKDIR /workdir/arduino
RUN wget --no-check-certificate -q https://downloads.arduino.cc/${ARDUINO_VERSION}-linux64.tar.xz && \
	tar -xvf ${ARDUINO_VERSION}-linux64.tar.xz && rm -f ${ARDUINO_VERSION}-linux64.tar.xz && \
    cd ${ARDUINO_VERSION} && \
    ./install.sh && \
    cd .. && \
    curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh


WORKDIR /home/${USER_NAME}/.arduino15
COPY arduino-cli.yaml ./

WORKDIR /workdir/arduino
RUN \
    arduino-cli core update-index && \
    arduino-cli core install SparkFun:apollo3 && \
    arduino-cli lib install ArduinoBLE@1.3.1

# apply patches
COPY ArduinoBLE-1.3.1-patch/src/utility/ATT.cpp /home/${USER_NAME}/Arduino/libraries/ArduinoBLE/src/utility/ATT.cpp
COPY ArduinoBLE-1.3.1-patch/src/BLEDevice.cpp /home/${USER_NAME}/Arduino/libraries/ArduinoBLE/src/BLEDevice.cpp
COPY ArduinoBLE-1.3.1-patch/src/BLEDevice.h /home/${USER_NAME}/Arduino/libraries/ArduinoBLE/src/BLEDevice.h

WORKDIR /workdir/project

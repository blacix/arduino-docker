# Base image which contains global dependencies
FROM ubuntu:20.04 as base

WORKDIR /workdir

ENV ARDUINO_VERSION="arduino-1.8.13"

# System dependencies
ARG arch=amd64
RUN mkdir /workdir/project && \
	apt update -y && apt upgrade -y && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
        wget \
        curl \
        xz-utils \
        ca-certificates \
        && \
    apt -y clean && apt -y autoremove && rm -rf /var/lib/apt/lists/*


# install arduino and arduino-cli
ENV PATH="/workdir/arduino/bin:${PATH}"
WORKDIR /workdir/arduino
RUN wget --no-check-certificate -q https://downloads.arduino.cc/${ARDUINO_VERSION}-linux64.tar.xz && \
	tar -xvf ${ARDUINO_VERSION}-linux64.tar.xz && rm -f ${ARDUINO_VERSION}-linux64.tar.xz && \
    cd ${ARDUINO_VERSION} && \
    ./install.sh && \
    cd .. && \
    curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh



WORKDIR /root/.arduino15
COPY arduino-cli.yaml ./

WORKDIR /workdir/arduino
RUN \
    arduino-cli core update-index && \
    arduino-cli core install SparkFun:apollo3 && \
    arduino-cli lib install ArduinoBLE@1.2.0


WORKDIR /workdir/project

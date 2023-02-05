FROM arm64v8/alpine as target-arm64

FROM arm32v7/alpine as target-armv7

FROM target-$TARGETARCH$TARGETVARIANT as builder

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Installing dependencies
RUN apk add mosquitto-clients
RUN apk add raspberrypi
RUN ln -s /opt/vc/bin/vcgencmd /usr/bin/vcgencmd

# Run app.sh when the container launches
CMD ["./app.sh"]